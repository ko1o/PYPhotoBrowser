//
//  UIImage+Tool.h
//  42-彩票
//
//  Created by 谢培艺 on 15/9/18.
//  Copyright (c) 2015年 谢培艺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PYTool)
+ (UIImage *)iconClipWithOldImage:(UIImage *)oldImage;
+ (instancetype)imageStretchableImageWithImageName:(NSString *)imageName;
- (instancetype)resetSizeOfImageDataWithMaxSize:(NSInteger)maxSize;
- (NSData *)resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize;
/**
 * 改变图像的尺寸（画质好像没变---待测）
 */
+ (UIImage *) scaleFromImage:(UIImage *)image toSize:(CGSize)size;
/**
 * 保持原来的长宽比，生成一个缩略图
 */
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;
/**
 * 字符串转图片
 */
+ (instancetype)imageFromString:(NSString *)string;
/**
 * 图片转字符串
 */
+ (NSString *)imageToString:(UIImage *)image;
@end
