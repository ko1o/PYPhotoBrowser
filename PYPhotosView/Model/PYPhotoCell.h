//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//  用于图片浏览/预览时的cell

#import <UIKit/UIKit.h>
@class PYPhoto,PYPhotoView,PYPhotosView;

@interface PYPhotoCell : UICollectionViewCell

/** 图片模型 */
@property (nonatomic, strong) PYPhoto *photo;
/** 本地相册图片 */
@property (nonatomic, strong) UIImage *image;
/** cell上的photoView */
@property (nonatomic, weak) PYPhotoView *photoView;
/** 存储cell的collectionView */
@property (nonatomic, weak) UICollectionView *collectionView;
/** 放在最底下的contentScrollView(所有子控件都添加在这里) */
@property (nonatomic, weak) UIScrollView *contentScrollView;

/** 快速创建PYPhotoCell的方法 */
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

@end
