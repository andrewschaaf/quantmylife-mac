
#import "QuantMyLifeAppDelegate.h"

#import "InputIdleSignal.h"
#import "MousePositionSignal.h"

@implementation QuantMyLifeAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    aboutController = [[AboutController alloc] init];
    prefsController = [[PreferencesController alloc] init];
    
    signals = [NSMutableArray array];
    [signals addObject:[[InputIdleSignal alloc] init]];
    [signals addObject:[[MousePositionSignal alloc] init]];
}

- (IBAction)showPreferences:(id)sender
{
    [prefsController showPreferences];
}

- (IBAction)showAbout:(id)sender
{
    [aboutController showAbout];
}

@end
