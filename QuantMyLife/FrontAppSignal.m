
#import "FrontAppSignal.h"
#import "JSON.h"


#define FRONT_APP_SAMPLE_INTERVAL_MS   200


@implementation FrontAppSignal

- (id)init
{
    self = [super initWithSlug:@"front-app" formatVersion:1 sampleMs:FRONT_APP_SAMPLE_INTERVAL_MS];
    if (self) {
        lastPid = -2;
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)sample:(NSTimer *)timer
{
	NSDictionary *appInfo = [[NSWorkspace sharedWorkspace] activeApplication];
    NSNumber *pidNum = [appInfo objectForKey:@"NSApplicationProcessIdentifier"];
    long pid = (pidNum ? [pidNum longValue] : -1);
    if (pid != lastPid) {
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        [info
            setObject:[appInfo objectForKey:@"NSApplicationBundleIdentifier"]
            forKey:@"app"];
        [info setObject:pidNum forKey:@"pid"];
        lastPid = pid;
        
        NSString *json = [info JSONRepresentation];
        [self logEvent:[json dataUsingEncoding:NSUTF8StringEncoding]];
    }
}

@end
