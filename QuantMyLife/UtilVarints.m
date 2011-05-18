
#import "UtilVarints.h"


@implementation UtilVarints

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}


+ (NSData*)encodeUnsignedFromNumber:(NSNumber*)n {
	return [UtilVarints encodeUnsignedFromUnsignedLongLong:[n unsignedLongLongValue]];
}

+ (NSData*)encodeUnsignedFromUnsignedLongLong:(unsigned long long)x {
	
	unsigned char bytes[11];
	int i = 0;
	
	while (1) {
		if (x < 128) {
			bytes[i] = x;
			return [NSData dataWithBytes:(void*)bytes length:(i + 1)];
		}
		if (x >= 128) {
			bytes[i] = (x % 128) | 128;
			i++;
			x = x >> 7;
		}
	}
}

@end
