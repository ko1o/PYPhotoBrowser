//
//  PYExampleViewController.m
//  PYPhotosViewExample
//
//  Created by 谢培艺 on 16/6/2.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import "PYExampleViewController.h"
#import "AppDelegate.h"
#import "PYPhotosView.h"

@interface PYExampleViewController ()

@end

@implementation PYExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置背景色
    self.view.backgroundColor = PYColor(102, 153, 255);
    
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
    
    // 2.1 创建一个photosView
    PYPhotosView *photosView = [PYPhotosView photosView:imageUrls];
    
    // 2.2 设置居中
    photosView.center = self.view.center;
    
    // 3. 添加photosView
    [self.view addSubview:photosView];
}

@end
