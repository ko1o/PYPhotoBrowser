//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import "PYPhotosNavigationController.h"
#import "PYPhotoBrowserConst.h"

@implementation PYPhotosNavigationController

// 初始化
- (void)setup
{
    // 设置主题颜色
    UINavigationBar *navBar = self.navigationBar;
    // 设置背景颜色
    navBar.barTintColor = PYBarTintColor;
    // 设置背景图片(为了避免appearance背景图影响)
    [navBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
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
