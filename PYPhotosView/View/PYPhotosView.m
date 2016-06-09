//
//  PYPhotosView.m
//  新浪微博
//
//  Created by 谢培艺 on 15/12/16.
//  Copyright © 2015年 iphone5solo. All rights reserved.
//

#import "PYPhotosView.h"
#include "PYPhotoView.h"
#import "PYPhoto.h"
#import "PYConst.h"
#import "PYPhotosViewController.h"

@interface PYPhotosView()

/** 图片大小*/
@property (nonatomic, assign) CGSize photoSize;

/** 添加图片按钮*/
@property (nonatomic, strong) UIButton *addImageButton;

/** 处理事件的控制器 */
@property (nonatomic, strong) PYPhotosViewController *handleController;

/** 记录scrollerView的x值 */
@property (nonatomic, assign) CGFloat originalX;

@end

@implementation PYPhotosView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 获取当前控制器
        PYPhotosViewController *photosViewController = [[PYPhotosViewController alloc] init];
        self.handleController = photosViewController;
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        // 初始化
        self.photoMargin = PYPhotoMargin;
        self.photoWidth = PYPhotoWidth;
        self.photoHeight = PYPhotoHeight;
        self.photosMaxCol = PYPhotosMaxCol;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.x = 0;
    }
    return self;
}

+ (instancetype)photosView
{
    return [[self alloc] init];
}

+ (instancetype)photosView:(NSArray *)photos
{
    // 封装photos为模型
    NSMutableArray *photosM = [NSMutableArray array];
    for (NSString *url in photos) {
        PYPhoto *photo = [PYPhoto photoWithUrl:url];
        [photosM addObject:photo];
    }
    PYPhotosView *photosView = [self photosView];
    photosView.photos = photosM;
    return photosView;
}

/** 点击添加图片调用此方法 */
- (void)addImageDidClicked
{
    // 发出添加图片的通知
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[PYAddImageDidClickedNotification] = self.images;
    NSNotification *notifaction = [[NSNotification alloc] initWithName:PYAddImageDidClickedNotification object:nil userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notifaction];
}

/** 添加图片按钮 */
- (UIButton *)addImageButton
{
    if (!_addImageButton) {
        UIButton *addImage = [[UIButton alloc] init];
        [addImage setBackgroundImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
        [addImage addTarget:self action:@selector(addImageDidClicked) forControlEvents:UIControlEventTouchUpInside];
        _addImageButton = addImage;
    }
    return _addImageButton;
}

/** 根据图片个数和图片状态自动计算出大小 */
- (CGSize)sizeWithPhotoCount:(NSInteger)count photosState:(NSInteger)state
{
    NSInteger maxCount = 0; // 每行最多个数
    NSInteger cols = 0; // 列数
    NSInteger rows = 0; // 行数
    CGFloat photosViewW = 0;
    CGFloat photosViewH = 0;
    // 根据图片个数设置图片
    if (state == PYPhotosViewStateDidCompose) { // 已经发布
        maxCount = count == 4 ? 2 : self.photosMaxCol;
        // 设置图片
    }else if (state == PYPhotosViewStateWillCompose){ // 未发布
        maxCount = 4;
        if (count < 9) count ++;
    }
    
    cols = (count >= maxCount) ? maxCount : count;
    rows = (count + maxCount - 1) / maxCount;
    
    photosViewW = cols * self.photoWidth + (cols - 1) * self.photoMargin;
    photosViewH = rows * self.photoHeight + (rows - 1) * self.photoMargin;
    
    return CGSizeMake(photosViewW, photosViewH);
}

- (void)setImages:(NSMutableArray *)images
{
    _images = images;
    
    // 移除添加图片按钮
    [self.addImageButton removeFromSuperview];
    // 设置图片状态
    self.photosState = PYPhotosViewStateWillCompose;
    
    NSInteger imageCount = images.count;
    
    // 添加相应的图片
    while (self.subviews.count < imageCount) { // UIImageView不够，需要创建
        PYPhotoView *photoView = [[PYPhotoView alloc] init];
        photoView.photosView = self;
        [self addSubview:photoView];
    }
    
    // 设置图片
    for(int i = 0; i < self.subviews.count; i++)
    {
        PYPhotoView *photoView = self.subviews[i];
        // 设置标记
        photoView.tag = i;
        photoView.images = images;
        if (i < imageCount) {
            photoView.hidden = NO;
            // 设置图片
            photoView.image = images[i];
        }else{
            photoView.hidden = YES;
        }
    }

    // 刷新
    [self layoutSubviews];
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    // 移除添加图片按钮
    [self.addImageButton removeFromSuperview];
    // 设置图片状态
    self.photosState = PYPhotosViewStateDidCompose;
    
    NSInteger photoCount = self.photos.count;
    // 添加相应的图片
    while (self.subviews.count < photoCount) { // UIImageView不够，需要创建
        PYPhotoView *photoView = [[PYPhotoView alloc] init];
        photoView.photosView = self;
        photoView.photos = self.photos;
        [self addSubview:photoView];
    }
    
    // 设置图片
    for(int i = 0; i < self.subviews.count; i++)
    {
        PYPhotoView *photoView = self.subviews[i];
        // 设置标记
        photoView.tag = i;
        photoView.photos = self.photos;
        if (i < photoCount) {
            photoView.hidden = NO;
            // 设置图片
            photoView.photo = self.photos[i];
        }else{
            photoView.hidden = YES;
        }
    }
    
    // 设置contentSize和 self.size
    // 取出size
    CGSize size = [self sizeWithPhotoCount:self.photos.count photosState:self.photosState];
    self.contentSize = size;
    
    CGFloat width = size.width + self.originalX > PYScreenW ? PYScreenW - self.originalX : size.width;
    self.size = CGSizeMake(width, size.height);
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
    
    // 记录x值
    self.originalX = x;
    CGFloat width = CGRectGetMaxX(self.frame) > PYScreenW ? PYScreenW - self.originalX : self.frame.size.width;
    self.size = CGSizeMake(width, self.size.height);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger photosCount = self.photos.count > 0 ?  self.photos.count : self.images.count;
    NSInteger maxCol = self.photos.count > 0 ? self.photosMaxCol : 4;
    // 调整图片位置
    for (int i = 0; i < photosCount; i++) {
        PYPhotoView *photoView = self.subviews[i];
        NSInteger col = i % maxCol;
        NSInteger row = i / maxCol;
        
        photoView.y = row * (self.photoHeight + self.photoMargin);
        photoView.x = col * (self.photoWidth + self.photoMargin);
        photoView.width = self.photoWidth;
        photoView.height = self.photoHeight;
    }
    if (self.images.count < 9 && self.photosState == PYPhotosViewStateWillCompose) {
        [self addSubview:self.addImageButton];
        self.addImageButton.y = (self.images.count / 4) * (self.photoHeight + self.photoMargin);
        self.addImageButton.x = (self.images.count % 4) * (self.photoWidth + self.photoMargin);
        self.addImageButton.width = self.photoWidth;
        self.addImageButton.height = self.photoHeight;
    }
}

@end
