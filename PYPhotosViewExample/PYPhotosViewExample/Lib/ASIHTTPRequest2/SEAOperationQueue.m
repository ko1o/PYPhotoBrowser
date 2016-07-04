//
//  SOperationQueue.m
//  Ads
//
//  Created by hong7 on 09-7-11.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SEAOperationQueue.h"
#import "ASIHTTPRequest.h"

static SEAOperationQueue *shareQueue = NULL;

@implementation SEAOperationQueue


+(SEAOperationQueue *)mainQueue {
	if (!shareQueue) {
		[[SEAOperationQueue alloc] init];
	}
	return shareQueue;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (shareQueue == nil) {
            shareQueue = [super allocWithZone:zone];
            return shareQueue;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}


-(oneway void) release
{
    //do nothing
}

- (id)autorelease
{
	return self;
}

-(void)removeOperationsWithDelegate:(id) delegate {

	NSArray * operations = self.operations;
	for (NSOperation * op in operations) {
		if ([[(ASIHTTPRequest *)op delegate] isEqual:delegate]) {
			[(ASIHTTPRequest *)op setDelegate:nil];
//			[(ASIHTTPRequest *)op setDidFinishSelector:nil];
//			[(ASIHTTPRequest *)op setDidFailSelector:nil];
			[(ASIHTTPRequest *)op cancel];
		}
	}
	
}

@end
