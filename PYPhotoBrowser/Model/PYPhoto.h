//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import <UIKit/UIKit.h>
#if __has_include(<FLAnimatedImage/FLAnimatedImage.h>)
#import <FLAnimatedImage/FLAnimatedImage.h>
#else
#import "FLAnimatedImage.h"
#endif

@class PYPhotoView;

@interface PYPhoto : NSObject
    
/** 根据缩略图快速创建模型 */
+ (instancetype)photoWithThumbnailUrl:(NSString *)thumbnailUrl;
/** 根据原图快速创建模型 */
+ (instancetype)photoWithOriginalUrl:(NSString *)originalUrl;
    
/** thumbnail_pic 图片缩略图地址 */
@property (nonatomic, copy) NSString *thumbnail_pic;
/** original_pic 图片原图地址 */
@property (nonatomic, copy) NSString *original_pic;

/** 缩略图 */
@property (nonatomic, strong) UIImage *thumbnailImage;
/** 原图 */
@property (nonatomic, strong) UIImage *originalImage;
/** GIF图 */
@property (nonatomic, strong) FLAnimatedImage *animatedImage;
/** 图片加载进度 */
@property (nonatomic, assign) CGFloat progress;

/** 记录旋转前的大小（只记录最开始的大小） */
@property (nonatomic, assign) CGSize originalSize;
/** 旋转90°或者270°时的宽(默认为屏幕宽度) */
@property (nonatomic, assign) CGFloat verticalWidth;

@end
