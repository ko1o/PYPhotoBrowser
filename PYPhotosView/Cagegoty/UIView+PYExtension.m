//
//  UIView+extension.m
//  新浪微博
//
//  Created by 谢培艺 on 15/12/8.
//  Copyright © 2015年 iphone5solo. All rights reserved.
//

#import "UIView+PYExtension.h"

@implementation UIView (PYExtension)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.origin.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;

}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;

}


- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;

}
- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

/** 设置锚点 */
- (CGPoint)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
    return anchorPoint;
}

/** 根据手势触摸点修改相应的锚点，就是沿着触摸点做相应的手势操作 */
- (CGPoint)setAnchorPointBaseOnGestureRecognizer:(UIGestureRecognizer *)gr
{
    // 手势为空 直接返回
    if (!gr) return CGPointZero;
    
    // 创建锚点
    CGPoint anchorPoint;
    if ([gr isKindOfClass:[UIPinchGestureRecognizer class]]) { // 捏合手势
        // 当触摸开始时，获取两个触摸点
        CGPoint point1 = [gr locationOfTouch:0 inView:gr.view];
        CGPoint point2 = [gr locationOfTouch:1 inView:gr.view];
        anchorPoint.x = (point1.x + point2.x) / 2 / gr.view.width;
        anchorPoint.y = (point1.y + point2.y) / 2 / gr.view.height;
    } else if ([gr isKindOfClass:[UITapGestureRecognizer class]]) { // 点击手势
        // 获取触摸点
        CGPoint point = [gr locationOfTouch:0 inView:gr.view];
        anchorPoint.x = point.x / gr.view.width;
        anchorPoint.y = point.y / gr.view.height;
    };
    return [self setAnchorPoint:anchorPoint forView:self];
}

@end
