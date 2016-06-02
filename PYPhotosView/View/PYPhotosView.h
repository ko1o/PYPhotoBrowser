//
//  PYPhotosView.h
//  新浪微博
//
//  Created by 谢培艺 on 15/12/16.
//  Copyright © 2015年 iphone5solo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYConst.h"
@class PYPhotoView,PYPhotosView;

typedef enum{
    PYPhotosViewStateWillCompose = 0,   // 未发布
    PYPhotosViewStateDidCompose = 1     // 已发布
}PYPhotosViewState;

@interface PYPhotosView : UIScrollView

/** 网络图片相册 */
@property (nonatomic, strong) NSArray *photos;
/** 本地相册图片数组 */
@property (nonatomic, strong) NSMutableArray *images;
/** 所有图片的状态 */
@property (nonatomic, assign) NSInteger photosState;

/** 图片间距（默认为5） */
@property (nonatomic, assign) CGFloat photoMargin;
/** 图片的宽高（正方形）默认为70 */
@property (nonatomic, assign) CGFloat photoWH;
/** 每行最多个数（默认为3） */
@property (nonatomic, assign) NSInteger photosMaxCol;

/** 快速创建photosView对象 */
+ (instancetype)photosView;
/** photos: 保存图片链接的数组 */
+ (instancetype)photosView:(NSArray *)photos;


/** 根据图片个数和图片状态自动计算出PYPhontosView的size */
- (CGSize)sizeWithPhotoCount:(NSInteger)count photosState:(NSInteger)state;

@end
