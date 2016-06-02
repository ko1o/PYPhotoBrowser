//
//  PYPhotoView.h
//  新浪微博
//
//  Created by 谢培艺 on 15/12/16.
//  Copyright © 2015年 iphone5solo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
@class PYPhotosView;
@class PYPhoto, PYPhotoCell;

@interface PYPhotoView : UIImageView

@property (nonatomic, strong) NSString *photo;

/** 微博图片相册*/
@property (nonatomic, strong) NSArray *photos;

@property (nonatomic, strong) NSArray *images;

/** 是否放大*/
@property (nonatomic, assign) BOOL isBig;

/** 原来的frame*/
@property (nonatomic, assign) CGRect orignalFrame;

/** 在window呈现的view*/
@property (nonatomic, strong) PYPhotoView *windowView;

@property (nonatomic, strong) PYPhotosView *photosView;

/** 每个photoView的photoCell */
@property (nonatomic, weak) PYPhotoCell *photoCell;

/** 是否正在预览*/
@property (nonatomic, assign) BOOL isPreview;


@end
