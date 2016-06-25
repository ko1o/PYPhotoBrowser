//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "UIView+PYExtension.h"
@class PYPhoto, PYPhotoCell, PYPhotosView, PYDALabeledCircularProgressView;

@interface PYPhotoView : UIImageView

/** 图片模型 */
@property (nonatomic, strong) PYPhoto *photo;
/** 网络图片*/
@property (nonatomic, strong) NSArray *photos;
/** 本地相册图片 */
@property (nonatomic, strong) NSMutableArray *images;

/** 是否放大状态 */
@property (nonatomic, assign) BOOL isBig;
/** 是否正在预览*/
@property (nonatomic, assign) BOOL isPreview;
/** 原来的frame*/
@property (nonatomic, assign) CGRect orignalFrame;
/** 放大的倍数 */
@property (nonatomic, assign) CGFloat scale;
/** 判断是否是旋转手势 */
@property (nonatomic, assign, getter=isRotationGesture) BOOL rotationGesture;

/** 在window呈现的view*/
@property (nonatomic, strong) PYPhotoView *windowView;
/** 父控件photosView */
@property (nonatomic, weak) PYPhotosView *photosView;
/** 每个photoView的photoCell */
@property (nonatomic, weak) PYPhotoCell *photoCell;
/** 加载进度view */
@property (weak, nonatomic) PYDALabeledCircularProgressView *progressView;

- (void)imageDidPinch:(UIPinchGestureRecognizer *)pinch;
- (void)photoDidRotation:(UIRotationGestureRecognizer *)rotation;

@end
