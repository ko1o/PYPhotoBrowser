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

/** 记录scrollerView的x值 */
@property (nonatomic, assign) CGFloat originalX;

@end

static PYPhotosViewController *_handleController;

@implementation PYPhotosView



#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 只用一个控制器
        if (!_handleController) _handleController = [[PYPhotosViewController alloc] init];
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

+ (instancetype)photosView:(NSArray *)photos layoutType:(PYPhotosViewLayoutType)type
{
    PYPhotosView *photosView = [self photosView:photos];
    photosView.layoutType = type;
    return photosView;
}

+ (instancetype)photosView:(NSArray *)photos photosMaxCol:(NSInteger)maxCol
{
    PYPhotosView *photosView = [self photosView:photos];
    photosView.photosMaxCol = maxCol;
    return photosView;
}

#pragma mark - setter方法
- (void)setLayoutType:(PYPhotosViewLayoutType)layoutType
{
    _layoutType = layoutType;
    
    // 刷新
    self.photosMaxCol = self.photosMaxCol > 0 ? self.photosMaxCol : PYPhotosMaxCol;
}

- (void)setPhotosMaxCol:(NSInteger)photosMaxCol
{
    // 设置了线性布局（photosMaxCol 再次设置也无效）
    if (self.layoutType == PYPhotosViewLayoutTypeLine) photosMaxCol = self.photos.count;
    
    _photosMaxCol = photosMaxCol;
    
    // 刷新
    self.photos = self.photos;
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
    self.py_size = CGSizeMake(width, size.height);
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

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
    
    // 记录x值
    self.originalX = x;
    CGFloat width = CGRectGetMaxX(self.frame) > PYScreenW ? PYScreenW - self.originalX : self.frame.size.width;
    self.py_size = CGSizeMake(width, self.py_height);
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
        if (count < PYImageCountWhenWillCompose) count ++;
    }
    
    cols = (count >= maxCount) ? maxCount : count;
    rows = (count + maxCount - 1) / maxCount;
    
    photosViewW = cols * self.photoWidth + (cols - 1) * self.photoMargin;
    photosViewH = rows * self.photoHeight + (rows - 1) * self.photoMargin;
    
    return CGSizeMake(photosViewW, photosViewH);
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
        
        photoView.py_y = row * (self.photoHeight + self.photoMargin);
        photoView.py_x = col * (self.photoWidth + self.photoMargin);
        photoView.py_width = self.photoWidth;
        photoView.py_height = self.photoHeight;
    }
    if (self.images.count < PYImageCountWhenWillCompose && self.photosState == PYPhotosViewStateWillCompose) {
        [self addSubview:self.addImageButton];
        self.addImageButton.py_y = (self.images.count / 4) * (self.photoHeight + self.photoMargin);
        self.addImageButton.py_x = (self.images.count % 4) * (self.photoWidth + self.photoMargin);
        self.addImageButton.py_width = self.photoWidth;
        self.addImageButton.py_height = self.photoHeight;
    }
}

@end
