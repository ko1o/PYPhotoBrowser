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

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 创建图片
        PYPhotoView *imageView = [[PYPhotoView alloc] init];
        imageView.isBig = YES;
        [self.contentView addSubview:imageView];
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
    self.photoView.center = CGPointMake(self.width * 0.5, self.height * 0.5);
}

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
    self.photoView.center = CGPointMake(self.width * 0.5, self.height * 0.5);
}

static NSString * const reuseIdentifier = @"Cell";
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath
{
    
    PYPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.collectionView = collectionView;

    return cell;
}



@end
