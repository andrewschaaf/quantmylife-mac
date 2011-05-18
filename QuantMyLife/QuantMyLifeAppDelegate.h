
#import <Cocoa/Cocoa.h>
#import "InputIdleSignal.h"

@interface QuantMyLifeAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
    
    NSMutableArray *signals;
}

@property (assign) IBOutlet NSWindow *window;

@end
