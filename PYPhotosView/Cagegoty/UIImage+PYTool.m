//
//  UIImage+Tool.m
//  42-彩票
//
//  Created by 谢培艺 on 15/9/18.
//  Copyright (c) 2015年 谢培艺. All rights reserved.
//

#import "UIImage+PYTool.h"
#import <Foundation/NSObject.h>

@implementation UIImage (PYTool)

+ (instancetype)imageStretchableImageWithImageName:(NSString *)imageName
{
    // 拉伸图片
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    
    return image;
}

/**
 * maxSize : 允许最大图片 100KB 返回新图片
 */
- (instancetype)resetSizeOfImageDataWithMaxSize:(NSInteger)maxSize
{
    NSData *imageData = [self resetSizeOfImageData:self maxSize:maxSize];
    UIImage *newImage = [UIImage imageWithData:imageData];

    return newImage;
}

// 控制图片大小（像素）
/**
 * maxSize : 允许最大图片 100KB
 */
- (NSData *)resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize
{
  
    //先调整分辨率
    CGSize newSize = CGSizeMake(source_image.size.width, source_image.size.height);
    
    CGFloat tempHeight = newSize.height / 1024;
    CGFloat tempWidth = newSize.width / 1024;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(source_image.size.width / tempWidth, source_image.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(source_image.size.width / tempHeight, source_image.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [source_image drawInRect:CGRectMake(0,0,newSize.width + 5,newSize.height + 5)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
    NSUInteger sizeOrigin = [imageData length];
    NSUInteger sizeOriginKB = sizeOrigin / 1024;
    if (sizeOriginKB > maxSize) {
        NSData *finallImageData = UIImageJPEGRepresentation(newImage,0.40);
          NSLog(@"压缩图片----");
        return finallImageData;
    }
    
    return imageData;
}
// 图片转字符串
+ (NSString *)imageToString:(UIImage *)image
{
    NSLog(@"图片的宽：%f--高：%f-",image.size.width, image.size.height);
    NSData *imageData = [image resetSizeOfImageData:image maxSize:100];
    NSLog(@"imagedata---%zd", imageData.length);
    NSString *imageDataString = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSLog(@"图片大小----%zd", imageDataString.length);
    return imageDataString;
}

// 字符串转图片
+ (instancetype)imageFromString:(NSString *)string
{
    NSData *data=[[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    UIImage *image = [UIImage imageWithData:data];
    return image;
}




+ (UIImage *)iconClipWithOldImage:(UIImage *)oldImage
{
    CGFloat newW = oldImage.size.width ;
    CGFloat newH = oldImage.size.height ;
    
    // 2. 开启上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(newH, newH), NO, 0.0);
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 画大圈
    UIBezierPath *path1 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0,  newW,  newH)];
    [[UIColor whiteColor] set];
    CGContextAddPath(ctx, path1.CGPath);
    CGContextFillPath(ctx);
    
    // 3. 画圈
    // 拼接途径
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, oldImage.size.width, oldImage.size.height)];
    // 裁剪
    [path addClip];
    
    // 绘制图片
    [oldImage drawAtPoint:CGPointMake(0, 0)];
    // 添加到上下文
    
    // 把path添加到上下文
    CGContextAddPath(ctx, path.CGPath);
    
    
    // 获取新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 4. 关闭上下文
    UIGraphicsEndImageContext();
    return newImage;
}

// 改变图像的尺寸，方便上传服务器
+ (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{ 
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    //Determine whether the screen is retina
    if([[UIScreen mainScreen] scale] == 2.0){                UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    }else if([[UIScreen mainScreen] scale] == 3.0){                UIGraphicsBeginImageContextWithOptions(size, NO, 3.0);
    }else{
        UIGraphicsBeginImageContext(size);
    }
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}
//2.保持原来的长宽比，生成一个缩略图
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    //Determine whether the screen is retina
    if([[UIScreen mainScreen] scale] == 2.0){                UIGraphicsBeginImageContextWithOptions(asize, NO, 2.0);
    }else if([[UIScreen mainScreen] scale] == 3.0){                UIGraphicsBeginImageContextWithOptions(asize, NO, 3.0);
    }else{
        UIGraphicsBeginImageContext(asize);
    }
    
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}


@end
