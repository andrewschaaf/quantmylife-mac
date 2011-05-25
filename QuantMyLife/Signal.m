
#import "Signal.h"


@implementation Signal

- (id)initWithSlug:(NSString*)slug formatVersion:(int)formatVersion sampleMs:(unsigned long long)sampleMs
{
    self = [super init];
    if (self) {
        
        NSString *qmlDirName;
        if ([[[NSBundle mainBundle] bundlePath] isEqualToString:@"/Applications/QuantMyLife.app"]) {
            qmlDirName = @"QuantMyLife";
        }
        else {
            NSLog(@"Dev mode.");
            qmlDirName = @"QuantMyLife-dev";
        }
        
        // Create signalDir if needed
        NSError *err;
        NSString *signalDir = [NSString stringWithFormat:@"%@/%@/signals/%@",
                                    [@"~/Library/Application Support" stringByExpandingTildeInPath],
                                    qmlDirName,
                                    slug];
        [[NSFileManager defaultManager]
                 createDirectoryAtPath:signalDir
                 withIntermediateDirectories:YES
                 attributes:nil
                 error:&err];
        //HANDLE err
        
        // Create file
        NSDate *date = [NSDate date];
        unsigned long long ms = (long long)([date timeIntervalSince1970] * 1000);
        NSString *path = [NSString stringWithFormat:@"%@/%@-%.3d-Z.v%d",
                                    signalDir,
                                    [date
                                        descriptionWithCalendarFormat:@"%Y-%m-%d-%H-%M-%S"
                                        timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]
                                        locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]],
                                    (int)(ms % 1000),
                                    formatVersion];
        if (![[NSFileManager defaultManager] createFileAtPath:path contents:[NSData data] attributes:nil]) {
            //HANDLE
        }
        fileHandle = [[NSFileHandle fileHandleForWritingToURL:[NSURL fileURLWithPath:path] error:&err] retain];
        if (!fileHandle) {
			//HANDLE
		}
        
        [NSTimer
             scheduledTimerWithTimeInterval:(sampleMs / 1000.0)
             target:self
             selector:@selector(sample:)
             userInfo:nil
             repeats:YES];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)logEvent:(NSData*)data
{
    NSDate *date = [NSDate date];
    unsigned long long ms = (long long)([date timeIntervalSince1970] * 1000);
    
    // time delta
	[fileHandle writeData:[UtilVarints encodeUnsignedFromUnsignedLongLong:(ms - lastLoggedMs)]];
	
	// data length
	[fileHandle writeData:[UtilVarints encodeUnsignedFromUnsignedLongLong:[data length]]];
    
	// data
	[fileHandle writeData:data];
    
    numLogged++;
	lastLoggedMs = ms;
}

- (void)sample:(NSTimer*)timer
{
    
}

@end
