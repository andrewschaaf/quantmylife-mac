
#import <Foundation/Foundation.h>
#import "Signal.h"
#import "UtilVarints.h"


@interface InputIdleSignal : Signal {
@private
    
}

+ (unsigned long long)idleNanoseconds;

@end
