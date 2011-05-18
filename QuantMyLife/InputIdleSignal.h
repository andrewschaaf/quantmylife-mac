
#import <Foundation/Foundation.h>
#import "Signal.h"
#import "UtilVarints.h"


@interface InputIdleSignal : Signal {
@private
    unsigned long long lastIdleMs;
    
    BOOL wasActive;
    
    NSData *becameActive;
    NSData *becameIdle;
}

+ (unsigned long long)idleNanoseconds;

@end
