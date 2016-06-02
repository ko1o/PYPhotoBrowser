//
//  NSString+XLStringExpand.m
//  18-QQ聊天窗口
//
//  Created by 谢培艺 on 15/8/8.
//  Copyright (c) 2015年 谢培艺. All rights reserved.
//

#import "NSString+XLStringExpand.h"

@implementation NSString (XLStringExpand)

+ (CGSize)stringWithText:(NSString *)text andMaxSize:(CGSize)maxSize andFont:(UIFont *)font
{
    NSDictionary *attr = @{NSFontAttributeName : font};
    CGSize rect = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
    return rect;
}

- (CGSize)stringWithMaxSize:(CGSize)maxSize andFont:(UIFont *)font
{

    NSDictionary *attr = @{NSFontAttributeName : font};
    CGSize rect = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
    return rect;

}


@end
