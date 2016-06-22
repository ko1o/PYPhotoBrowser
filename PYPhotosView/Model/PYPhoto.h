//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PYPhotoView;

@interface PYPhoto : NSObject


+ (instancetype)photoWithUrl:(NSString *)url;

/** thumbnail_pic 图片缩略图地址*/
@property (nonatomic, copy) NSString *thumbnail_pic;

/** 图片加载进度 */
@property (nonatomic, assign) CGFloat progress;

/** 记录旋转前的大小（只记录最开始的大小） */
@property (nonatomic, assign) CGSize originalSize;

/** 旋转90°或者270°时的宽(默认为屏幕宽度) */
@property (nonatomic, assign) CGFloat verticalWidth;

@end
