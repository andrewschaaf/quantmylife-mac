
#import "Signal.h"


@implementation Signal

- (id)init
{
    self = [super init];
    if (self) {
        [NSTimer
             scheduledTimerWithTimeInterval:0.5
             target:self
             selector:@selector(sample:)
             userInfo:nil
             repeats:YES];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)sample:(NSTimer*)timer
{
    
}

@end
