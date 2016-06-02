//
//  PYPhotosViewController.m
//  PYPhotosView
//
//  Created by 谢培艺 on 16/6/2.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import "PYPhotosViewController.h"
#import "PYPhotosReaderController.h"
#import "PYConst.h"

@interface PYPhotosViewController ()

@property (nonatomic, strong) PYPhotosReaderController *photosReader;

/** 相册图片*/
@property (nonatomic, strong) NSMutableArray *images;

/** 从相册中选择的图片*/
@property (nonatomic, strong) NSMutableArray *selectedPhotos;

@end

@implementation PYPhotosViewController

- (instancetype)init
{
    if ([super init]) {
        // 初始化
        [self setUp];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setUp
{
    // 添加通知
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(bigImageDidClicked:) name:PYBigImageDidClikedNotification object:nil];
    [center addObserver:self selector:@selector(smallImageDidClieked:) name:PYSmallgImageDidClikedNotification object:nil];
    [center addObserver:self selector:@selector(imagePageDidChanged:) name:PYImagePageDidChangedNotification object:nil];
}

- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)imagePageDidChanged:(NSNotification *)notification
{
    // 取出选中图片
    NSDictionary *userInfo = notification.userInfo;
    PYPhotoView *photoView = userInfo[PYImagePageDidChangedNotification];
    self.photosReader.selectedPhotoView = photoView;
}

- (void)bigImageDidClicked:(NSNotification *)notification
{
    // 取出选中图片
    NSDictionary *userInfo = notification.userInfo;
    PYPhotoView *photoView = userInfo[PYBigImageDidClikedNotification];
    // 创建图片浏览器
    PYPhotosReaderController *photosReader = [PYPhotosReaderController readerController];
    photosReader.selectedPhotoView = photoView;
    // 成为子控制器
    [PYCurrentController addChildViewController:photosReader];
    self.photosReader = photosReader;
    
    // 打开一个新的窗口
    UIWindow *lastWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 设置窗口级别(最高级)
    lastWindow.windowLevel = UIWindowLevelStatusBar;
    // 呈现在某一个window上
    [self.photosReader showPhotosToWindow:lastWindow];
}

// 还原
- (void)smallImageDidClieked:(NSNotification *)notification
{
    [self.photosReader hiddenPhoto];
}

@end
