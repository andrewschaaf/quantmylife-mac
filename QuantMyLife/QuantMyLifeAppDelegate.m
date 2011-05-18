
#import "QuantMyLifeAppDelegate.h"

@implementation QuantMyLifeAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    signals = [NSMutableArray array];
    [signals addObject:[[InputIdleSignal alloc] init]];
}

@end
