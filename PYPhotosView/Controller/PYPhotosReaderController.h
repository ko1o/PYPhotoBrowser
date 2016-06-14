//
//  PYPhotosReaderController.h
//  youzhu
//
//  Created by 谢培艺 on 16/2/18.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//  预览图片的新弹出窗口控制器

#import <UIKit/UIKit.h>
@class PYPhotoView,PYPhotosView;

@interface PYPhotosReaderController : UICollectionViewController

+ (instancetype)readerController;

- (void)showPhotosToWindow:(UIWindow *)window;

/** 选中的照片的view*/
@property (nonatomic, weak) PYPhotoView *selectedPhotoView;

/** 复制的view*/
@property (nonatomic, weak) PYPhotoView *beginView;

- (void)hiddenPhoto;

@end
