//
//  PYPhotosPreviewController.h
//  youzhu
//
//  Created by 谢培艺 on 16/2/26.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import "PYPhotosReaderController.h"
@class PYPhotosPreviewController;

@protocol PYPhotosPreviewControllerDelegate <NSObject>
@optional

- (void)photosPreviewController:(PYPhotosPreviewController *)previewController didImagesChanged:(NSMutableArray *)images;

@end


@interface PYPhotosPreviewController : PYPhotosReaderController

/** 预览的图片*/
@property (nonatomic, weak) id<PYPhotosPreviewControllerDelegate> delegate;

+ (instancetype)previewController;

@end
