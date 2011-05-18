
#import <Foundation/Foundation.h>


@interface UtilVarints : NSObject {
@private
    
}

+ (NSData*)encodeUnsignedFromNumber:(NSNumber*)n;
+ (NSData*)encodeUnsignedFromUnsignedLongLong:(unsigned long long)x;

@end

