//
//  PYPhotoBrowseView.m
//  PYPhotosViewExample
//
//  Created by 谢培艺 on 16/8/7.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//


#import "PYPhotoBrowseView.h"
#import "PYPhotosView.h"
#import "PYPhoto.h"
#import "PYPhotoView.h"


@interface PYPhotoBrowseView ()

/** 存储每一个photoView */
@property (nonatomic, strong) PYPhotosView *photosView;

/** 是否正在浏览 */
@property (nonatomic, assign) BOOL showing;

@end

@implementation PYPhotoBrowseView


- (void)show
{
    // 加载数据源方法
    if ([self.dataSource respondsToSelector:@selector(imagesForBrowse)]) {
        self.images = [self.dataSource imagesForBrowse];
    }
   
    if ([self.dataSource respondsToSelector:@selector(currentIndex)]) {
        self.currentIndex = [self.dataSource currentIndex];
    }
    
    PYPhotosView *photosView = [PYPhotosView photosView];
    self.photosView = photosView;
    // 用户自己控制
//    photosView.controlSelf = YES;
    
    NSMutableArray *photosM = [NSMutableArray array];
    for (int i = 0; i < self.images.count; i++)
    {
        // 创建模型
        PYPhoto *photo = [[PYPhoto alloc] init];
        // 设置图片
        photo.originalImage = self.images[i];
        // 添加模型
        [photosM addObject:photo];
    }
    photosView.photos = photosM;
    
    // 取出photoView
    PYPhotoView *selectedPhotoView = photosView.subviews[self.currentIndex];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    // 遍历所有photoFrame记录原始frame
    for (PYPhotoView *photoView in self.photosView.subviews) {
        photoView.orignalFrame = photoView.frame;
    }
    // 发出通知
    userInfo[PYBigImageDidClikedNotification] = selectedPhotoView;
    userInfo[PYPhotoBrowseViewKey] = self;
    NSNotification *notification = [[NSNotification alloc] initWithName:PYBigImageDidClikedNotification object:self.photosView userInfo:userInfo];
    [center postNotification:notification];
}

- (void)hidden
{
    self.photosView = nil;
    PYPhotoView *selectedPhotoView = self.photosView.subviews[self.currentIndex];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[PYSmallgImageDidClikedNotification] = selectedPhotoView;
    NSNotification *notification = [[NSNotification alloc] initWithName:PYSmallgImageDidClikedNotification object:self.photosView userInfo:userInfo];
    [center postNotification:notification];
}

#pragma mark - PYPhotoViewDelegate
- (void)didSingleClick:(PYPhotoView *)photoView
{
    if ([self.delegate respondsToSelector:@selector(photoBrowseView:didSingleClickedImage:index:)]) {
        [self.delegate photoBrowseView:self didSingleClickedImage:photoView.image index:photoView.tag];
        if (self.images) return;
    }
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    // suoxiao
    userInfo[PYSmallgImageDidClikedNotification] = photoView;
    NSNotification *notification = [[NSNotification alloc] initWithName:PYSmallgImageDidClikedNotification object:self.photosView userInfo:userInfo];
    [center postNotification:notification];

}

- (void)didLongPress:(PYPhotoView *)photoView
{
    if ([self.delegate respondsToSelector:@selector(photoBrowseView:didLongPressImage:index:)]) {
        [self.delegate photoBrowseView:self didLongPressImage:photoView.image index:photoView.tag];
        if (self.images) return;
    }
}

@end
