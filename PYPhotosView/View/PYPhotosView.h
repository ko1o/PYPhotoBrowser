//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYConst.h"
@class PYPhotoView,PYPhotosView, PYMovie;
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

@end

@interface PYPhotosView : UIScrollView

/** 代理 */
@property (nonatomic, weak) id<PYPhotosViewDelegate> delegate;

/** 网络图片相册 */
@property (nonatomic, strong) NSArray *photos;
/** 本地相册图片数组(默认最多为九张,当传入图片数组长度超过九张时，取前九张) */
@property (nonatomic, strong) NSMutableArray *images;
/** 视频链接(视频来自网络) **/
@property (nonatomic, copy) NSString *movieNetworkUrl;
/** 本地视频地址(带有文件类型后缀) */
@property (nonatomic, copy) NSString *movieLocalUrl;
/** 视频模型 */
@property (nonatomic, strong) PYMovie *movie;

/** 所有图片的状态（默认为已发布状态） */
@property (nonatomic, assign) PYPhotosViewState photosState;
/** 图片布局（默认为流水布局） */
@property (nonatomic, assign) PYPhotosViewLayoutType layoutType;
/** 图片分页指示类型(默认为pageControll。当图片超过九张，改为label显示) */
@property (nonatomic, assign) PYPhotosViewPageType pageType;

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

/** 快速创建photosView对象 */
+ (instancetype)photosView;
/** photos : 保存图片链接的数组 */
+ (instancetype)photosViewWithPhotos:(NSArray *)photos;
/** images : 存储本地图片的数组 */
+ (instancetype)photosViewWithImages:(NSMutableArray *)images;

/**
 * photos : 保存图片链接的数组
 * type : 布局类型（默认为流水布局）
 */
+ (instancetype)photosView:(NSArray *)photos layoutType:(PYPhotosViewLayoutType)type;

/** 
 * photos : 保存图片链接的数组
 * maxCol : 每行最多显示图片的个数
 */
+ (instancetype)photosView:(NSArray *)photos photosMaxCol:(NSInteger)maxCol;

/** 根据图片个数和图片状态自动计算出PYPhontosView的size */
- (CGSize)sizeWithPhotoCount:(NSInteger)count photosState:(NSInteger)state;

/**
 * 刷新图片(未发布)
 * images : 新的图片数组
 */
- (void)reloadDataWithImages:(NSMutableArray *)images;

@end
