
#import "QuantMyLifeAppDelegate.h"

@implementation QuantMyLifeAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    aboutController = [[AboutController alloc] init];
    prefsController = [[PreferencesController alloc] init];
    
    signals = [NSMutableArray array];
    [signals addObject:[[InputIdleSignal alloc] init]];
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
