//
//  PYPhotoCell.h
//  youzhu
//
//  Created by 谢培艺 on 16/2/19.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PYPhoto,PYPhotoView,PYPhotosView;

@interface PYPhotoCell : UICollectionViewCell

/** 图片地址 */
@property (nonatomic, strong) NSString *photo;

/** 本地相册图片 */
@property (nonatomic, strong) UIImage *image;

/** cell上的photoView */
@property (nonatomic, strong) PYPhotoView *photoView;

/** 存储cell的collectionView */
@property (nonatomic, weak) UICollectionView *collectionView;

/** 快速创建PYPhotoCell的方法 */
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

@end
