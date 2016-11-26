//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import "PYPhotosViewController.h"
#import "PYPhotosReaderController.h"
#import "PYPhotosPreviewController.h"
#import "PYConst.h"
#import "PYPhotoView.h"
#import "PYPhotoCell.h"
#import "PYNavigationController.h"
#import "PYPhotoBrowseView.h"
#import "PYPhotosView.h"

@interface PYPhotosViewController ()

/** 图片浏览控制器 */
@property (nonatomic, strong) PYPhotosReaderController *photosReader;
/** 图片预览控制器 */
@property (nonatomic, strong) PYPhotosPreviewController *photosPreviewController;
/** 相册图片 */
@property (nonatomic, strong) NSMutableArray *images;
/** 从相册中选择的图片 */
@property (nonatomic, strong) NSMutableArray *selectedPhotos;

@end

@implementation PYPhotosViewController

- (instancetype)init
{
    if (self = [super init]) {
        // 初始化
        [self setUp];
    }
    return self;
}

// 初始化
- (void)setUp
{
    // 添加通知
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(bigImageDidClicked:) name:PYBigImageDidClikedNotification object:nil];
    [center addObserver:self selector:@selector(smallImageDidClieked:) name:PYSmallgImageDidClikedNotification object:nil];
    [center addObserver:self selector:@selector(imagePageDidChanged:) name:PYImagePageDidChangedNotification object:nil];
    [center addObserver:self selector:@selector(previewImageDidClicked:) name:PYPreviewImagesDidChangedNotification object:nil];
}

- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 处理图片事件
// 图片单击
- (void)imagePageDidChanged:(NSNotification *)notification
{
    // 取出选中图片
    NSDictionary *userInfo = notification.userInfo;
    PYPhotoView *photoView = userInfo[PYImagePageDidChangedNotification];
    self.photosReader.selectedPhotoView = photoView;
}

// 图片放大
- (void)bigImageDidClicked:(NSNotification *)notification
{
    // 取出选中图片
    NSDictionary *userInfo = notification.userInfo;
    PYPhotoView *photoView = userInfo[PYBigImageDidClikedNotification];
    // 创建图片浏览器
    PYPhotosReaderController *photosReader = [PYPhotosReaderController readerController];
    photosReader.selectedPhotoView = photoView;
    self.photosReader = photosReader;
    
    // 打开一个新的窗口
    PYPhotoBrowseView *lastWindow = userInfo[PYPhotoBrowseViewKey];
    // 设置是否自动旋转
    lastWindow.autoRotateImage = photoView.photosView.autoRotateImage && lastWindow.autoRotateImage;
    if (!lastWindow) {
        lastWindow = [[PYPhotoBrowseView alloc] initWithFrame:CGRectMake(0, 0, PYScreenW, PYScreenH)];
    }
    // 设置窗口级别(最高级)
    lastWindow.windowLevel = UIWindowLevelAlert;
    // 呈现在某一个window上
    [self.photosReader showPhotosToWindow:lastWindow];
}

// 还原
- (void)smallImageDidClieked:(NSNotification *)notification
{
    // 获取当前屏幕显示的cell的indexPath
    NSIndexPath *indexPath = [[self.photosReader.collectionView indexPathsForVisibleItems] firstObject];
    // 取出选中的cell
    PYPhotoCell *selectedCell = (PYPhotoCell *)[self.photosReader.collectionView cellForItemAtIndexPath:indexPath];
    // 设置选中的photoView
    self.photosReader.selectedPhotoView.windowView = selectedCell.photoView;
    
    [self.photosReader hiddenPhoto];
    self.photosReader = nil;
}

// 图片预览（未发布）
- (void)previewImageDidClicked:(NSNotification *)notification
{
    // 取出选中图片
    NSDictionary *userInfo = notification.userInfo;
    PYPhotoView *photoView = userInfo[PYPreviewImagesDidChangedNotification];
    // 创建图片浏览器
    PYPhotosPreviewController *photosPreviewVc = [PYPhotosPreviewController previewController];
    self.photosPreviewController = photosPreviewVc;
    photosPreviewVc.selectedPhotoView = photoView;
    PYNavigationController *nav = [[PYNavigationController alloc] initWithRootViewController:photosPreviewVc];
    [self.navigationController pushViewController:photosPreviewVc animated:YES];
    // 修复未发布点击不能预览BUG
    UIViewController *presentFromVc = [UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController;
    if (!presentFromVc) { // 如果为空，就使用根控制器
        presentFromVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    [presentFromVc presentViewController:nav animated:YES completion:nil];
    
    // 获取当前photosView
    PYPhotosView *photosView = photoView.photosView;
    // 调用代理方法
    if ([photosView.delegate respondsToSelector:@selector(photosView:didPreviewImagesWithPreviewControlelr:)]) {
        [photosView.delegate photosView:photosView didPreviewImagesWithPreviewControlelr:self.photosPreviewController];
    }
}

@end
