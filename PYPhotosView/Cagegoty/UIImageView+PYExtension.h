//
//  UIImageView+Extension.h
//  youzhu
//
//  Created by 谢培艺 on 16/3/2.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (PYExtension)
/** 设置动画*/
- (void)makeAnimation:(int)count preName:(NSString *)preName perTime:(CGFloat)perTime;
@end
