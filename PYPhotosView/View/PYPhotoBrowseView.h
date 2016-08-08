//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//  图片浏览时的Window,用于图片浏览时自定义（用户自己控制显示/隐藏）

#import <UIKit/UIKit.h>
@class PYPhotoBrowseView;
#import "PYPhotoView.h"

@protocol PYPhotoBrowseViewDelegate <NSObject>

@optional

/**
 * 图片浏览将要显示时调用
 */
- (void)photoBrowseView:(PYPhotoBrowseView *)photoBrowseView willShowWithImages:(NSArray *)images index:(NSInteger)index;
/**
 * 图片浏览已经显示时调用
 */
- (void)photoBrowseView:(PYPhotoBrowseView *)photoBrowseView didShowWithImages:(NSArray *)images index:(NSInteger)index;
/**
 * 图片浏览将要隐藏时调用
 */
- (void)photoBrowseView:(PYPhotoBrowseView *)photoBrowseView willHiddenWithImages:(NSArray *)images index:(NSInteger)index;
/**
 * 图片浏览已经隐藏时调用
 */
- (void)photoBrowseView:(PYPhotoBrowseView *)photoBrowseView didHiddenWithImages:(NSArray *)images index:(NSInteger)index;
/**
 * 图片单击时调用
 */
- (void)photoBrowseView:(PYPhotoBrowseView *)photoBrowseView didSingleClickedImage:(UIImage *)image index:(NSInteger)index;
/**
 * 图片长按时调用
 */
- (void)photoBrowseView:(PYPhotoBrowseView *)photoBrowseView didLongPressImage:(UIImage *)image index:(NSInteger)index;

@end

@protocol PYPhotoBrowseViewDataSource <NSObject>

@required
/** 返回将要浏览的图片（UIImage）数组 */
- (NSArray *)imagesForBrowse;

@optional
/** 返回默认显示图片的索引(默认为0) */
- (NSInteger)currentIndex;

/** 默认显示图片相对于主窗口的位置 */
- (CGRect)frameFormWindow;

/** 消失回到相对于住窗口的指定位置 */
- (CGRect)frameToWindow;

@end


@interface PYPhotoBrowseView  : UIWindow <PYPhotoViewDelegate>

/** 代理 */
@property (nonatomic, weak) id<PYPhotoBrowseViewDelegate> delegate;
/** 数据源代理 */
@property (nonatomic, weak) id<PYPhotoBrowseViewDataSource> dataSource;

/** 用来浏览的图片（UIImage）数组 */
@property (nonatomic, copy) NSArray *images;

/** 用来记录当前下标 */
@property (nonatomic, assign) NSInteger currentIndex;

/**
 * 浏览图片
 */
- (void)show;

/**
 * 隐藏
 */
- (void)hidden;

@end
