//
//  UIView+extension.h
//  新浪微博
//
//  Created by 谢培艺 on 15/12/8.
//  Copyright © 2015年 iphone5solo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (PYExtension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;


/** 设置锚点 */
- (CGPoint)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view;

/** 根据手势触摸点修改相应的锚点，就是沿着触摸点对self做相应的手势操作 */
- (CGPoint)setAnchorPointBaseOnGestureRecognizer:(UIGestureRecognizer *)gr;

@end
