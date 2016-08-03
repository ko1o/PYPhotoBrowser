//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//  浏览图片的控制器（一般用于网络片浏览）

#import <UIKit/UIKit.h>
@class PYPhotoView, PYPhotosView;

@interface PYPhotosReaderController : UICollectionViewController

+ (instancetype)readerController;

- (void)showPhotosToWindow:(UIWindow *)window;
- (void)hiddenPhoto;

/** 选中的照片的view*/
@property (nonatomic, weak) PYPhotoView *selectedPhotoView;

/** 复制的view*/
@property (nonatomic, strong) PYPhotoView *beginView;

@end
