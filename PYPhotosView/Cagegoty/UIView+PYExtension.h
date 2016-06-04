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

/* 判断当前view是否和window有交集（传入nil就代表最上面的窗口）*/
- (BOOL)isInWindow:(UIWindow *)window;

/** 判断当前view是否在屏幕上 */
- (BOOL)isDisplayedInScreen;
@end
