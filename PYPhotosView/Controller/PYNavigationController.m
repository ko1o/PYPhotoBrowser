//
//  PYNavigationController.m
//  WarehousingSystem
//
//  Created by 谢培艺 on 16/5/31.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//
#import "PYNavigationController.h"
#import "PYConst.h"
@interface PYNavigationController ()

@end

@implementation PYNavigationController

// 初始化
- (void)setup
{
    // 设置主题颜色
    UINavigationBar *navBar = self.navigationBar;
    // 设置背景颜色
    navBar.barTintColor = PYBarTintColor;
    // 设置主题颜色
    navBar.tintColor = [UIColor whiteColor];
    // 设置字体颜色
    NSDictionary *attr = @{ NSForegroundColorAttributeName : [UIColor whiteColor],
                            NSFontAttributeName : [UIFont boldSystemFontOfSize:20]
                            };
    [navBar setTitleTextAttributes:attr];
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

// 根据最上面的控制器来控制statusBarStyle
- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}

@end
