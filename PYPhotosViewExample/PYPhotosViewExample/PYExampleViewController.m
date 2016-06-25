//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import "PYExampleViewController.h"
#import "AppDelegate.h"
#import "PYPhotosView.h"
#import "PYPublishExampleViewController.h"

@interface PYExampleViewController ()

@end

@implementation PYExampleViewController

// 初始化
- (void)setup
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(publishDidCicked)];
    self.title = @"示例控制器";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化
    [self setup];
    
    // 1. 创建图片链接数组
    NSMutableArray *imageUrls = [NSMutableArray array];

    // 添加图片链接
    for (int i = 0; i < 8; i++) {
        // 图片链接
        NSString *imageUrl = [NSString stringWithFormat:@"https://github.com/iphone5solo/learngit/raw/master/imagesForPhotosView/image%02d.jpg", i + 1];
        // 添加图片链接到数组中
        [imageUrls addObject:imageUrl];
    }
    // 添加动态图
    [imageUrls addObject:@"https://github.com/iphone5solo/learngit/raw/master/imagesForPhotosView/image10.gif"];
    
    // 2.1 创建一个流水布局photosView
    PYPhotosView *flowPhotosView = [PYPhotosView photosView];
    flowPhotosView.photos = imageUrls;
    // 设置分页指示类型
    flowPhotosView.pageType = PYPhotosViewPageTypeLabel;
    flowPhotosView.py_centerX = self.view.py_centerX;
    flowPhotosView.py_y = 20 + 64;
    
    // 2.2 创建一个线性布局photosView
    PYPhotosView *linePhotosView = [PYPhotosView photosView:imageUrls layoutType:PYPhotosViewLayoutTypeLine];
    linePhotosView.py_x = PYMargin;
    linePhotosView.py_width = self.view.py_width - 2 * PYMargin;
    linePhotosView.py_y = CGRectGetMaxY(flowPhotosView.frame) + 2 * PYMargin;
    
    // 3. 添加photosView
    [self.view addSubview:flowPhotosView];
    [self.view addSubview:linePhotosView];
}

#pragma mark publishDidCicked 
// 点击发布时调用
- (void)publishDidCicked
{
    PYPublishExampleViewController *publishVc = [[PYPublishExampleViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:publishVc];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
