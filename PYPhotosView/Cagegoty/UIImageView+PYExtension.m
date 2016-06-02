//
//  UIImageView+Extension.m
//  youzhu
//
//  Created by 谢培艺 on 16/3/2.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import "UIImageView+PYExtension.h"

@implementation UIImageView (PYExtension)
- (void)makeAnimation:(int)count preName:(NSString *)preName perTime:(CGFloat)perTime
{
    // 判断是否执行动画
    if(![self isAnimating])
    {
        
        // 创建一个可变数组装图片
        NSMutableArray *arrayM = [NSMutableArray array];
        // 1. 有缓存的加载方式
        {
            // 加载图片到数组中
            for(int i = 0; i < count; i++)
            {
                // 获取图片名称
                NSString *imgName = [NSString stringWithFormat:@"%@%02d", preName, i];
    
                // 根据图片名称获取图片
                UIImage *image = [UIImage imageNamed:imgName];
    
    
                // 把图片加载到数组中
                [arrayM addObject:image];
            }
        }

        // 把数组图片加载到图片框中
        self.animationImages = arrayM;
        
        // 设置动画时间
        self.animationDuration = [arrayM count] * perTime;
        
        self.contentMode = UIViewContentModeCenter;
        
        // 开启动画
        [self startAnimating];
    }
    
    
}

@end
