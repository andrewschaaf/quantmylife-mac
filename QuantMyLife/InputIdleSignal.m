
#import "InputIdleSignal.h"

#define INPUT_IDLE_SAMPLE_INTERVAL_MS   500
#define INPUT_IDLE_FUDGE_MS             50

@implementation InputIdleSignal

- (id)init
{
    self = [super initWithSlug:@"input-idle" formatVersion:1 sampleMs:INPUT_IDLE_SAMPLE_INTERVAL_MS];
    if (self) {
        becameActive = [[UtilVarints encodeUnsignedFromUnsignedLongLong:1] retain];
        becameIdle = [[UtilVarints encodeUnsignedFromUnsignedLongLong:2] retain];
        wasActive = NO;
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}


- (void)sample:(NSTimer*)timer
{
    unsigned long long idleMs = [InputIdleSignal idleNanoseconds] / 1000000ull;
    
    if (idleMs < (INPUT_IDLE_SAMPLE_INTERVAL_MS + INPUT_IDLE_FUDGE_MS)) {
        if ( ! wasActive) {
            [self logEvent:becameActive];
            wasActive = YES;
        }
    }
    else {
        if (wasActive) {
            [self logEvent:becameIdle];
            wasActive = NO;
        }
    }
    
    lastIdleMs = idleMs;
}


// The following method uses code from idler.c

/*****************************************
 * idler.c
 *
 * Uses IOKit to figure out the idle time of the system. The idle time
 * is stored as a property of the IOHIDSystem class; the name is
 * HIDIdleTime. Stored as a 64-bit int, measured in ns.
 *
 * The program itself just prints to stdout the time that the computer
 has
 * been idle in seconds.
 *
 * Compile with gcc -Wall -framework IOKit -framework Carbon idler.c -o
 * idler
 *
 * Copyright (c) 2003, Stanford University
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 are
 * met:
 * Redistributions of source code must retain the above copyright
 notice,
 * this list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright
 notice,
 * this list of conditions and the following disclaimer in the
 documentation
 * and/or other materials provided with the distribution.
 *
 * Neither the name of Stanford University nor the names of its
 contributors
 * may be used to endorse or promote products derived from this software
 * without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS
 * IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


+ (unsigned long long)idleNanoseconds
{
	//### idle ###
	mach_port_t masterPort;
	io_iterator_t iter;
	io_registry_entry_t curObj;
	
	IOMasterPort(MACH_PORT_NULL, &masterPort);
	IOServiceGetMatchingServices(masterPort,
								 IOServiceMatching("IOHIDSystem"),
								 &iter);
	if (iter == 0) {
		//fatal_error
	}
	
	curObj = IOIteratorNext(iter);
	if (curObj == 0) {
		// fatal_error
	}
	
	CFMutableDictionaryRef properties = 0;
	CFTypeRef obj;
	
	if (IORegistryEntryCreateCFProperties(curObj, &properties, kCFAllocatorDefault, 0) == KERN_SUCCESS && properties != NULL) {
		obj = CFDictionaryGetValue(properties, CFSTR("HIDIdleTime"));
		CFRetain(obj);
	}
	else {
		// fatal_error
	}
	
	CFTypeID type = CFGetTypeID(obj);
	uint64_t nanoseconds;
	
	if (type == CFDataGetTypeID()) {
		CFDataGetBytes((CFDataRef) obj,
					   CFRangeMake(0, sizeof(nanoseconds)), 
					   (UInt8*) &nanoseconds);
    }
	else if (type == CFNumberGetTypeID()) {
		CFNumberGetValue((CFNumberRef)obj,
						 kCFNumberSInt64Type,
						 &nanoseconds);
    }
	else {
		// error: unsupported type
	}
	
	CFRelease(obj);
	IOObjectRelease(curObj);
	IOObjectRelease(iter);
	CFRelease((CFTypeRef)properties);
	
	return (unsigned long long)nanoseconds;
}


@end
