//
//  NSString+XLStringExpand.h
//  18-QQ聊天窗口
//
//  Created by 谢培艺 on 15/8/8.
//  Copyright (c) 2015年 谢培艺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface NSString (XLStringExpand)

+ (CGSize)stringWithText:(NSString *)text andMaxSize:(CGSize)maxSize andFont:(UIFont *)font;

- (CGSize)stringWithMaxSize:(CGSize)maxSize andFont:(UIFont *)font;
@end
