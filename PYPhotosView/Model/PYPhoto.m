//
//  PYPhoto.m
//  新浪微博
//
//  Created by 谢培艺 on 15/12/16.
//  Copyright © 2015年 iphone5solo. All rights reserved.
//

#import "PYPhoto.h"

@implementation PYPhoto

- (instancetype)init
{
    if (self = [super init]) {
        self.progress = 0.0;
    }
    return self;
}

+ (instancetype)photoWithUrl:(NSString *)url
{
    PYPhoto *photo = [[PYPhoto alloc] init];
    photo.thumbnail_pic = url;
    return photo;
}
@end
