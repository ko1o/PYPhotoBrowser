//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import "PYPhotoCell.h"
#import "PYPhoto.h"
#import "PYPhotoView.h"
#import "PYPhotosView.h"
#import "PYConst.h"
#import "UIImageView+WebCache.h"
#import "PYDALabeledCircularProgressView.h"
#import "PYMovie.h"

@implementation PYPhotoCell

// 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 创建contentScrollView
        UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, PYScreenW, PYScreenH)];
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
    }
    return self;
}

- (void)setPhotoView:(PYPhotoView *)photoView
{
    _photoView = photoView;
    
    // 绑定photoCell
    photoView.photoCell = self;
}

// 设置视频
- (void)setMovie:(PYMovie *)movie
{
    _movie = movie;
    // 设置图片状态
    self.photoView.photosView.photosState = PYPhotosViewStateDidCompose;
    self.photoView.movie = movie;
    self.photo.originalSize = self.photoView.py_size;
    self.photo.verticalWidth = self.photo.originalSize.width;
    // 放大图片
    // 设置scrollView的大小
    self.contentScrollView.py_size = self.photoView.py_size;
    self.contentScrollView.center = CGPointMake(self.py_width * 0.5, self.py_height * 0.5);
    self.photoView.center = CGPointMake(self.contentScrollView.py_width * 0.5, self.contentScrollView.py_height * 0.5);
}

// 设置图片（图片来源自网络）
- (void)setPhoto:(PYPhoto *)photo
{
    _photo = photo;
    // 设置图片状态
    self.photoView.photosView.photosState = PYPhotosViewStateDidCompose;

    [self.photoView setPhoto:photo];
    
    // 取出图片大小
    CGSize imageSize = self.photoView.image.size;
    CGFloat width;
    CGFloat height;
    if (self.photo.originalSize.width > self.photo.originalSize.height * 2) { // （原始图片）宽大于高的两倍
        height = PYScreenH;
        width = height * self.photo.originalSize.height / self.photo.originalSize.width;
    } else { // （原始图片）高大于宽
        height = PYScreenW * self.photo.originalSize.width / self.photo.originalSize.height > PYScreenH ? PYScreenH : PYScreenW * self.photo.originalSize.width / self.photo.originalSize.height;
        width = PYScreenW;
    }
    self.photoView.py_size = CGSizeMake(self.py_width, self.py_width * imageSize.height / imageSize.width);
    if (self.py_width > self.py_height) { // 横屏
        self.photoView.py_size = CGSizeMake(height, width);
    }
    
    self.photo.originalSize = self.photoView.py_size;
    self.photo.verticalWidth = self.photo.originalSize.width;
    
    // 放大图片
    // 设置scrollView的大小
    self.contentScrollView.py_size = self.photoView.py_size;
    self.contentScrollView.center = CGPointMake(self.py_width * 0.5, self.py_height * 0.5);
    self.photoView.center = CGPointMake(self.contentScrollView.py_width * 0.5, self.contentScrollView.py_height * 0.5);
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.contentScrollView.frame = self.bounds;
}

// 设置图片（图片来源自本地相册）
- (void)setImage:(UIImage *)image
{
    _image = image;
    self.photoView.image = image;
    // 设置图片状态
    self.photoView.photosView.photosState = PYPhotosViewStateWillCompose;
    // 隐藏进度条
    self.photoView.progressView.hidden = YES;

    // 取出图片大小
    CGSize imageSize = self.photoView.image.size;
    // 放大图片
    self.photoView.py_width = self.py_width;
    self.photoView.py_height = self.py_width * imageSize.height / imageSize.width;
    self.photoView.center = CGPointMake(self.photoView.py_width * 0.5, self.photoView.py_height * 0.5);
    // 设置scrollView的大小
    self.contentScrollView.py_size = self.photoView.py_size;
    self.contentScrollView.center = CGPointMake(self.py_width * 0.5, self.py_height * 0.5);
}


static NSString * const reuseIdentifier = @"Cell";

// 快速创建collectionCell
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath
{
    PYPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.py_size = CGSizeMake(collectionView.py_width - ((UICollectionViewFlowLayout *)collectionView.collectionViewLayout).minimumLineSpacing, collectionView.py_height);
    
    cell.collectionView = collectionView;
    return cell;
}

@end
