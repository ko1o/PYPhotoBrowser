//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (PY)
+ (void)py_showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)py_showError:(NSString *)error toView:(UIView *)view;
+ (void)py_showLoading:(NSString *)loading toView:(UIView *)view;
@end
