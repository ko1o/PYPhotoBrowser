//
//  SOperationQueue.h
//  Ads
//
//  Created by hong7 on 09-7-11.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SEAOperationQueue : NSOperationQueue {

}


+(SEAOperationQueue *)mainQueue;
-(void)removeOperationsWithDelegate:(id) delegate;
@end
