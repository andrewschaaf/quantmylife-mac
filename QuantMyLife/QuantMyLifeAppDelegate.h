
#import <Cocoa/Cocoa.h>

#import "AboutController.h"
#import "PreferencesController.h"

#import "InputIdleSignal.h"


@interface QuantMyLifeAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
    
    AboutController *aboutController;
    PreferencesController *prefsController;
    
    NSMutableArray *signals;
}

@property (assign) IBOutlet NSWindow *window;


- (IBAction)showPreferences:(id)sender;
- (IBAction)showAbout:(id)sender;


@end
