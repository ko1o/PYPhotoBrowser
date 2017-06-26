//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//  用于呈现一组图片、一个视频的视图（子控件为PYPhotoView的实例对象）

#import <UIKit/UIKit.h>
#import "PYPhotoBrowserConst.h"

@class PYPhotoView, PYPhotosView, PYPhotosPreviewController, PYPhoto;

typedef NS_ENUM(NSInteger, PYPhotosViewLayoutType) { // 布局类型
    PYPhotosViewLayoutTypeFlow = 0, // 流水布局
    PYPhotosViewLayoutTypeLine = 1  // 线性布局
};

typedef NS_ENUM(NSInteger, PYPhotosViewState) { // 图片状态
    PYPhotosViewStateWillCompose = 0,   // 未发布
    PYPhotosViewStateDidCompose = 1     // 已发布
};

typedef NS_ENUM(NSInteger, PYPhotosViewPageType) { // 分页类型
    PYPhotosViewPageTypeControll = 0, // pageControll（当图片超过九张，改为label显示）
    PYPhotosViewPageTypeLabel = 1  // label
};

@protocol PYPhotosViewDelegate <NSObject, UIScrollViewDelegate>

@optional
/**
 * 添加图片按钮选中时调用此方法
 * images : 当前存在的图片（未发布）数组
 */
- (void)photosView:(PYPhotosView *)photosView didAddImageClickedWithImages:(NSMutableArray *)images;

/** 
 * 图片未发布时进入浏览图片时调用此方法
 * previewControlelr : 预览图片时的控制器
 */
- (void)photosView:(PYPhotosView *)photosView didPreviewImagesWithPreviewControlelr:(PYPhotosPreviewController *)previewControlelr;

/**
 * 图片浏览将要显示时调用
 */
- (void)photosView:(PYPhotosView *)photosView willShowWithPhotos:(NSArray<PYPhoto *> *)photos index:(NSInteger)index;
/**
 * 图片浏览已经显示时调用
 */
- (void)photosView:(PYPhotosView *)photosView didShowWithPhotos:(NSArray<PYPhoto *> *)photos index:(NSInteger)index;
/**
 * 图片浏览将要隐藏时调用
 */
- (void)photosView:(PYPhotosView *)photosView willHiddenWithPhotos:(NSArray<PYPhoto *> *)photos index:(NSInteger)index;
/**
 * 图片浏览已经隐藏时调用
 */
- (void)photosView:(PYPhotosView *)photosView didHiddenWithPhotos:(NSArray<PYPhoto *> *)photos index:(NSInteger)index;

@end

@interface PYPhotosView : UIScrollView

/** 代理 */
@property (nonatomic, weak) id<PYPhotosViewDelegate> delegate;

/** 占位图 */
@property (nonatomic, strong) UIImage *placeholderImage;
/** 网络图片模型数组 */
@property (nonatomic, copy) NSArray<PYPhoto *> *photos;
/** 网络图片地址数组（缩略图） */
@property (nonatomic, copy) NSArray<NSString *> *thumbnailUrls;
/** 网络图片地址数组（原图） */
@property (nonatomic, copy) NSArray<NSString *> *originalUrls;
/** 本地相册图片(注意：存的是UIImage)数组(默认最多为九张,当传入图片数组长度超过九张时，取前九张) */
@property (nonatomic, strong) NSMutableArray<UIImage *> *images;

/** 所有图片的状态（默认为已发布状态） */
@property (nonatomic, assign) PYPhotosViewState photosState;
/** 图片布局（默认为流水布局） */
@property (nonatomic, assign) PYPhotosViewLayoutType layoutType;
/** 图片分页指示类型(默认为pageControll。当图片超过九张，改为label显示) */
@property (nonatomic, assign) PYPhotosViewPageType pageType;
/** 是否隐藏指示器，默认为：NO */
@property (nonatomic, assign) BOOL hiddenPageControl;

/** 图片间距（默认为5） */
@property (nonatomic, assign) CGFloat photoMargin;
/** 图片的宽 (默认为70) */
@property (nonatomic, assign) CGFloat photoWidth;
/** 图片的高 (默认为70) */
@property (nonatomic, assign) CGFloat photoHeight;

/** 每行最多个数（默认为3）, 当图片布局为线性布局时，此设置失效 */
@property (nonatomic, assign) NSInteger photosMaxCol;
/** 当图片上传前，最多上传的张数，默认为9 */
@property (nonatomic, assign) NSInteger imagesMaxCountWhenWillCompose;

/** 当屏幕旋转时，是否自动旋转图片 默认为YES */
@property (nonatomic, assign) BOOL autoRotateImage;
/** 当图片为4张时显示为是否两行两列，默认为YES */
@property (nonatomic, assign) BOOL autoLayoutWithWeChatSytle;

/** 显示动画时长：（默认0.5s） */
@property (nonatomic, assign) CGFloat showDuration;
/** 隐藏动画时长：（默认0.5s） */
@property (nonatomic, assign) CGFloat hiddenDuration;

/** 快速创建photosView对象 */
+ (instancetype)photosView;
/** photos : 保存图片链接的数组 */
+ (instancetype)photosViewWithThumbnailUrls:(NSArray<NSString *> *)thumbnailUrls originalUrls:(NSArray<NSString *> *)originalUrls;
/** images : 存储本地图片的数组 */
+ (instancetype)photosViewWithImages:(NSMutableArray<UIImage *> *)images;

/**
 * thumbnailUrls : 保存图片(缩略图)链接的数组
 * originalUrls : 保存图片(原图)链接的数组
 * type : 布局类型（默认为流水布局）
 */
+ (instancetype)photosViewWithThumbnailUrls:(NSArray<NSString *> *)thumbnailUrls originalUrls:(NSArray<NSString *> *)originalUrls layoutType:(PYPhotosViewLayoutType)type;

/** 
 * thumbnailUrls : 保存图片(缩略图)链接的数组
 * originalUrls : 保存图片(原图)链接的数组
 * maxCol : 每行最多显示图片的个数
 */
+ (instancetype)photosViewWithThumbnailUrls:(NSArray<NSString *> *)thumbnailUrls originalUrls:(NSArray<NSString *> *)originalUrls photosMaxCol:(NSInteger)maxCol;

/** 根据图片个数和图片状态自动计算出PYPhontosView的size */
- (CGSize)sizeWithPhotoCount:(NSInteger)count photosState:(NSInteger)state;

/**
 * 刷新图片(未发布)
 * images : 新的图片数组
 */
- (void)reloadDataWithImages:(NSMutableArray<UIImage *> *)images;

@end
