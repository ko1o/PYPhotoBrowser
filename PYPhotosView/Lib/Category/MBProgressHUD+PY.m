//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import "MBProgressHUD+PY.h"

@implementation MBProgressHUD (PY)
#pragma mark 显示信息
+ (void)py_show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 0.7秒之后再消失
    [hud hide:YES afterDelay:0.7];
}

#pragma mark 显示错误信息
+ (void)py_showError:(NSString *)error toView:(UIView *)view{
    [self py_show:error icon:@"error.png" view:view];
}

#pragma mark 显示正确信息
+ (void)py_showSuccess:(NSString *)success toView:(UIView *)view
{
    [self py_show:success icon:@"success.png" view:view];
}

#pragma mark 显示加载信息
+ (void)py_showLoading:(NSString *)loading toView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:NO];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
}


@end
