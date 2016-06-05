//
//  PYPhotoCell.m
//  youzhu
//
//  Created by 谢培艺 on 16/2/19.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import "PYPhotoCell.h"
#import "PYPhoto.h"
#import "PYPhotoView.h"
#import "PYPhotosView.h"
#import "PYConst.h"

@interface PYPhotoCell ()


@end

@implementation PYPhotoCell

// 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 创建contentScrollView
        UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        // 水平不允许有弹簧效果
        contentScrollView.alwaysBounceHorizontal = NO;
        // 取消滑动指示器
        contentScrollView.showsVerticalScrollIndicator = NO;
        contentScrollView.showsHorizontalScrollIndicator = NO;
        self.contentScrollView = contentScrollView;
        [self.contentView addSubview:contentScrollView];
        // 创建图片
        PYPhotoView *imageView = [[PYPhotoView alloc] init];
        imageView.isBig = YES;
        [self.contentScrollView addSubview:imageView];
        self.photoView = imageView;
        // 添加捏合手势
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self.photoView action:@selector(imageDidPinch:)];
        [self addGestureRecognizer:pinch];
    }
    return self;
}

- (void)setPhotoView:(PYPhotoView *)photoView
{
    _photoView = photoView;
    
    // 绑定photoCell
    photoView.photoCell = self;
}

// 设置图片（图片来源自网络）
- (void)setPhoto:(NSString *)photo
{
    _photo = photo;
    // 设置图片状态
    self.photoView.photosView.photosState = PYPhotosViewStateDidCompose;
    NSString *imageUrl = photo;
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:PYPlaceholderImage];
    
    // 取出图片大小
    CGSize imageSize = self.photoView.image.size;
    // 放大图片
    self.photoView.width = self.width;
    self.photoView.height = self.width * imageSize.height / imageSize.width;
    self.photoView.center = CGPointMake(self.photoView.width * 0.5, self.photoView.height * 0.5);
    // 设置scrollView的大小
    self.contentScrollView.size = self.photoView.size;
    self.contentScrollView.center = CGPointMake(PYScreenW * 0.5, PYScreenH * 0.5);
}

// 设置图片（图片来源自本地相册）
- (void)setImage:(UIImage *)image
{
    _image = image;
    self.photoView.image = image;
    // 设置图片状态
    self.photoView.photosView.photosState = PYPhotosViewStateWillCompose;
    // 取出图片大小
    CGSize imageSize = self.photoView.image.size;
    // 放大图片
    self.photoView.width = self.width;
    self.photoView.height = self.width * imageSize.height / imageSize.width;
    self.photoView.center = CGPointMake(self.photoView.width * 0.5, self.photoView.height * 0.5);
    // 设置scrollView的大小
    self.contentScrollView.size = self.photoView.size;
    self.contentScrollView.center = CGPointMake(PYScreenW * 0.5, PYScreenH * 0.5);
}

static NSString * const reuseIdentifier = @"Cell";

// 快速创建collectionCell
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath
{
    PYPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.collectionView = collectionView;
    return cell;
}

@end
