
#import "MousePositionSignal.h"
#import <Carbon/Carbon.h>


#define MOUSE_POSITION_SAMPLE_INTERVAL_MS   10


@implementation MousePositionSignal

- (id)init
{
    self = [super initWithSlug:@"mouse-position" formatVersion:1 sampleMs:MOUSE_POSITION_SAMPLE_INTERVAL_MS];
    if (self) {
        last_x = 0;
        last_y = 0;
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)sample:(NSTimer *)timer
{
    int x, y;
    HIPoint hiPoint;
	HIGetMousePosition(kHICoordSpaceScreenPixel, NULL, &hiPoint);
	x = hiPoint.x;
	y = hiPoint.y;
    
    if ((x != last_x) || (y != last_y)) {
		
		NSMutableData *data = [NSMutableData data];
		[data appendData:[UtilVarints encodeUnsignedFromUnsignedLongLong:x]];
		[data appendData:[UtilVarints encodeUnsignedFromUnsignedLongLong:y]];
		
		[self logEvent:data];
		
		last_x = x;
		last_y = y;
	}
}

@end
