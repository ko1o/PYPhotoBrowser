//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import "PYPhoto.h"
#import "PYPhotoBrowserConst.h"

@implementation PYPhoto

- (instancetype)init
{
    if (self = [super init]) {
        self.progress = 0.0;
        self.verticalWidth = PYScreenW;
    }
    return self;
}

/** 根据缩略图快速创建模型 */
+ (instancetype)photoWithThumbnailUrl:(NSString *)thumbnailUrl
{
    PYPhoto *photo = [[PYPhoto alloc] init];
    photo.thumbnail_pic = thumbnailUrl;
    return photo;
}

/** 根据原图快速创建模型 */
+ (instancetype)photoWithOriginalUrl:(NSString *)originalUrl
{
    PYPhoto *photo = [[PYPhoto alloc] init];
    photo.original_pic = originalUrl;
    return photo;
}

@end
