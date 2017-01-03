//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//  预览图片的控制器（一般用于图片发布时，本地图片的预览）

#import "PYPhotosReaderController.h"
@class PYPhotosPreviewController;

@protocol PYPhotosPreviewControllerDelegate <NSObject>
@optional
/** 
 * 图片改变时调用
 * previewController : 图片预览控制器
 * images : 改变后的图片数组
 */
- (void)photosPreviewController:(PYPhotosPreviewController *)previewController didImagesChanged:(NSMutableArray<UIImage *> *)images;

@end

@interface PYPhotosPreviewController : PYPhotosReaderController

/** 预览的图片*/
@property (nonatomic, weak) id<PYPhotosPreviewControllerDelegate> delegate;

/** 快速创建预览控制器 */
+ (instancetype)previewController;
/** 删除一张图片 */
- (void)deleteImage;
/** 关闭控制器 */
- (void)close;

@end
