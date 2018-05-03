//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//  继承DALabeledCircularProgressView类

#if __has_include(<DACircularProgress/DALabeledCircularProgressView.h>)
#import <DACircularProgress/DALabeledCircularProgressView.h>
#else
#import "DALabeledCircularProgressView.h"
#endif

@interface PYProgressView : DALabeledCircularProgressView
    
/** 设置加载进度 */
- (void)py_setProgress:(CGFloat)progress animated:(BOOL)animated;
    
@end
