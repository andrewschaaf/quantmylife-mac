
#import <Foundation/Foundation.h>
#import "Signal.h"

@interface FrontThingSignal : Signal {
@private
    NSString *lastJson;
}


+ (NSString*)findDocUrl:(AXUIElementRef)window;
+ (NSString*)findWebUrl:(AXUIElementRef)window;
+ (AXUIElementRef)findMainWindowOfApp:(AXUIElementRef)appElem;
+ (NSArray*)findDescentantsOf:(AXUIElementRef)top matchingRolePath:(NSArray*)rolePath;

@end
