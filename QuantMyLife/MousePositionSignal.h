
#import <Foundation/Foundation.h>
#import "Signal.h"

@interface MousePositionSignal : Signal {
@private
    int last_x, last_y;
}

@end
