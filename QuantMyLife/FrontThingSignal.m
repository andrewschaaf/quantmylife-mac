
#import "FrontThingSignal.h"
#import "JSON.h"


#define FRONT_THING_SAMPLE_INTERVAL_MS   200


@implementation FrontThingSignal

- (id)init
{
    self = [super initWithSlug:@"front-thing" formatVersion:1 sampleMs:FRONT_THING_SAMPLE_INTERVAL_MS];
    if (self) {
        lastJson = [@"" retain];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}


- (void)sample:(NSTimer *)timer
{
    NSDictionary *appInfo = [[NSWorkspace sharedWorkspace] activeApplication];
	long pid = [[appInfo objectForKey:@"NSApplicationProcessIdentifier"] longValue];
    NSString *bundleId = [appInfo objectForKey:@"NSApplicationBundleIdentifier"];
    
    // Find main window, if any
	AXUIElementRef appElem = AXUIElementCreateApplication((pid_t)pid);
	AXUIElementRef mainWindow = [FrontThingSignal findMainWindowOfApp:appElem];
    
    
    if (mainWindow) {
        NSString *url;
		url = [FrontThingSignal findDocUrl:mainWindow];
		if ((!url) && [bundleId isEqualToString:@"com.apple.Safari"]) {
            url = [FrontThingSignal findWebUrl:mainWindow];
		}
        
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        if (url != nil) {
            [info setObject:url forKey:@"url"];
        }
        NSString *json = [info JSONRepresentation];
        if ( ! [json isEqualToString:lastJson]) {
            [self logEvent:[json dataUsingEncoding:NSUTF8StringEncoding]];
            [lastJson release];
            lastJson = [json retain];
        }
    }
}


+ (NSString*)findDocUrl:(AXUIElementRef)window {
	/*
	 AXApplication
     AXWindow: AXDocument
	 */
	
	CFTypeRef value;
	NSString *s;
	
	if (AXUIElementCopyAttributeValue(window, (CFStringRef)NSAccessibilityDocumentAttribute, &value) == kAXErrorSuccess) {
		s = (NSString*)value;
		if ([s length] > 0) {
			return s;
		}
	}
	
	return nil;
}


+ (NSString*)findWebUrl:(AXUIElementRef)window {
	/*
	 AXApplication
     AXWindow
     AXGroup
     AXScrollArea
     AXWebArea: AXURL
	 */
	
	AXUIElementRef elem;
	CFTypeRef value;
	NSString *s;
	NSArray *elems = [FrontThingSignal
                      findDescentantsOf:window
                      matchingRolePath:[NSArray arrayWithObjects:@"AXGroup", @"AXScrollArea", @"AXWebArea", nil]];
	
	if ([elems count] == 1) {
		elem = (AXUIElementRef)[elems objectAtIndex:0];
		if (AXUIElementCopyAttributeValue(elem, (CFStringRef)NSAccessibilityURLAttribute, &value) == kAXErrorSuccess) {
			if (value) {
				s = [((NSURL*)value) absoluteString];
				if ([s length] > 0) {
					return s;
				}
			}
		}
	}
	return nil;
}


+ (AXUIElementRef)findMainWindowOfApp:(AXUIElementRef)appElem {
	
	/*
	 AXApplication
     AXWindow: AXMain == 1
	 */
	
	NSArray *appWindows = [FrontThingSignal
                           findDescentantsOf:appElem 
                           matchingRolePath:[NSArray arrayWithObjects:@"AXWindow", nil]];
	
	AXUIElementRef elem;
	CFTypeRef value;
	for (NSObject *obj in appWindows) {
		elem = (AXUIElementRef)obj;
		if (AXUIElementCopyAttributeValue(elem, (CFStringRef)NSAccessibilityMainAttribute, &value) == kAXErrorSuccess) {
			if ([((NSNumber*)value) intValue] == 1) {
				return elem;
			}
		}
	}
	
	return nil;
}


+ (NSArray*)findDescentantsOf:(AXUIElementRef)top matchingRolePath:(NSArray*)rolePath {
	
	AXUIElementRef elem;
	CFTypeRef value;
	NSArray *children;
	NSMutableArray *result = [NSMutableArray array];
	
	if ([rolePath count] >= 1) {
		NSString *role = [rolePath objectAtIndex:0];
		if (AXUIElementCopyAttributeValue(top, (CFStringRef)NSAccessibilityChildrenAttribute, &value) == kAXErrorSuccess) {
			if (CFGetTypeID(value) == CFArrayGetTypeID()) {
				children = (NSArray*)value;
				for (NSObject *obj in children) {
					elem = (AXUIElementRef)obj;
					if (AXUIElementCopyAttributeValue(elem, (CFStringRef)NSAccessibilityRoleAttribute, &value) == kAXErrorSuccess) {
						if (value && [role isEqual:(NSString*)value]) {
							
							if ([rolePath count] == 1) {
								[result addObject:obj];
							}
							else {
								NSMutableArray *subpath = [NSMutableArray arrayWithArray:rolePath];
								[subpath removeObjectAtIndex:0];
								NSArray *subresult = [FrontThingSignal findDescentantsOf:elem matchingRolePath:subpath];
								for (NSObject *x in subresult) {
									[result addObject:x];
								}
							}
						}
					}
				}
			}
		}
	}
	
	return result;
}

@end
