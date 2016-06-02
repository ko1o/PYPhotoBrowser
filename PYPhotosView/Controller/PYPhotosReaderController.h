//
//  PYPhotosReaderController.h
//  youzhu
//
//  Created by 谢培艺 on 16/2/18.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PYPhotoView,PYPhotosView;

@interface PYPhotosReaderController : UICollectionViewController

+ (instancetype)readerController;

- (void)showPhotosToWindow:(UIWindow *)window;

/** 选中的照片的view*/
@property (nonatomic, strong) PYPhotoView *selectedPhotoView;

/** 复制的view*/
@property (nonatomic, strong) PYPhotoView *beginView;

- (void)hiddenPhoto;

@end
