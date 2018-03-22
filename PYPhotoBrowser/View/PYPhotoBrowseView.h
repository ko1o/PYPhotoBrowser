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
 * 注意：实现该代理方法，默认点击退出浏览效果即失效！如果要实现该效果，可通过[photoBrowseView hidden];实现
 */
- (void)photoBrowseView:(PYPhotoBrowseView *)photoBrowseView didSingleClickedImage:(UIImage *)image index:(NSInteger)index;
/**
 * 图片长按时调用，可通过实现该代理方法处理长按手势
 * 注意：实现该代理方法，默认长按保存效果即失效！
 */
- (void)photoBrowseView:(PYPhotoBrowseView *)photoBrowseView didLongPressImage:(UIImage *)image index:(NSInteger)index;

@end

@protocol PYPhotoBrowseViewDataSource <NSObject>

@optional
/** 返回将要浏览的图片（UIImage）数组 */
- (NSArray<UIImage *> *)imagesForBrowse;

/** 返回将要浏览的图片链接(NSString)数组, 如果实现了- (NSArray *)imagesForBrowse;方法，则忽略此方法 */
- (NSArray<NSString *> *)imagesURLForBrowse;

/** 返回默认显示图片的索引(默认为0) */
- (NSInteger)currentIndex;

/** 默认显示图片相对于主窗口的位置 */
- (CGRect)frameFormWindow;

/** 消失回到相对于住窗口的指定位置 */
- (CGRect)frameToWindow;

@end


@interface PYPhotoBrowseView  : UIWindow <PYPhotoViewDelegate>

/** 代理<只允许初始化一次，即设置一次> */
@property (nonatomic, weak) id<PYPhotoBrowseViewDelegate> delegate;
/** 数据源代理 */
@property (nonatomic, weak) id<PYPhotoBrowseViewDataSource> dataSource;

/** 
 * 用来浏览的图片（UIImage）数组
 * 建议传入的UIImage是已下载的。如果是异步下载，请使用imagesURL
 * 如果设置了这个属性imagesURL失效
 * 使用此属性需要手动设置frameFormWindow和frameToWindow属性
 */
@property (nonatomic, copy) NSArray<UIImage *> *images;

/** 
 * 用来浏览的图片链接（NSString）数组
 * 使用此属性需要手动设置frameFormWindow和frameToWindow属性
 */
@property (nonatomic, copy) NSArray<NSString *> *imagesURL;
/**
 * 用来浏览的缩略图图片链接（NSString）数组
 * 使用此属性需要手动设置frameFormWindow和frameToWindow属性
 */
@property (nonatomic, copy) NSArray<NSString *> *thumbnailImagesURL;

/** 
 * 用来浏览的图片的控件（UIImageView）数组
 * 使用此属性即可自动计算frameFormWindow和frameToWindow
 */
@property (nonatomic, copy) NSArray<UIImageView *> *sourceImgageViews;

/** 
 * 占位图
 */
@property (nonatomic, strong) UIImage *placeholderImage;
/** 是否隐藏指示器，默认为：NO */
@property (nonatomic, assign) BOOL hiddenPageControl;

/** 用来记录当前下标 */
@property (nonatomic, assign) NSInteger currentIndex;

/** 
 * 默认显示图片相对于主窗口的位置(即从窗口的哪个位置显示)，
 * 注意：设置此属性时，showFromView属性失效
 */
@property (nonatomic, assign) CGRect frameFormWindow;
/** 传入从哪张图片(UIImageView)开始慢慢放大显示 */
@property (nonatomic, strong) UIView *showFromView;

/** 
 * 消失回到相对于住窗口的指定位置(即消失在窗口的哪个位置)
 * 注意：设置此属性时，hiddenToView属性失效
 */
@property (nonatomic, assign) CGRect frameToWindow;
/** 传入慢慢缩小到哪张图片(UIImageView)然后消失 */
@property (nonatomic, strong) UIView *hiddenToView;

/** 显示动画时长：（默认0.5s） */
@property (nonatomic, assign) CGFloat showDuration;
/** 隐藏动画时长：（默认0.5s） */
@property (nonatomic, assign) CGFloat hiddenDuration;

/** 当屏幕旋转时，是否自动旋转图片 默认为YES */
@property (nonatomic, assign) BOOL autoRotateImage;

/** 存储每一个photoView */
@property (nonatomic, strong) PYPhotosView *photosView;

/**
 * 浏览图片
 */
- (void)show;

/**
 * 隐藏
 */
- (void)hidden;

@end
