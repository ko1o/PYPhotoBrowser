//
//  PYPhoto.h
//  新浪微博
//
//  Created by 谢培艺 on 15/12/16.
//  Copyright © 2015年 iphone5solo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PYPhotoView;

@interface PYPhoto : NSObject


+ (instancetype)photoWithUrl:(NSString *)url;

/** thumbnail_pic 图片缩略图地址*/
@property (nonatomic, copy) NSString *thumbnail_pic;

/** 图片加载进度 */
@property (nonatomic, assign) CGFloat progress;

@end
