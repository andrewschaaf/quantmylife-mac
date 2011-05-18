
#import <Foundation/Foundation.h>
#import "UtilVarints.h"


@interface Signal : NSObject {
@private
    
    NSFileHandle *fileHandle;
	unsigned long long numLogged;
	unsigned long long lastLoggedMs;
}

- (id)initWithSlug:(NSString*)slug formatVersion:(int)formatVersion sampleMs:(unsigned long long)sampleMs;
- (void)logEvent:(NSData*)data;
- (void)sample:(NSTimer*)timer;


@end
