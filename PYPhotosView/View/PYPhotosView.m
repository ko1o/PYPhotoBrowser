//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import "PYPhotosView.h"
#include "PYPhotoView.h"
#import "PYPhoto.h"
#import "PYConst.h"
#import "PYPhotosViewController.h"
#import "PYPhotosReaderController.h"

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

@dynamic delegate;

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
        self.imageMaxCountWhenWillCompose = PYImageMaxCountWhenWillCompose;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.pageType = PYPhotosViewPageTypeControll;
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
    PYPhotosView *photosView = [self photosView];
    photosView.photos = photos;
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
    NSMutableArray *photosM = [NSMutableArray array];
    for (id photoUrl in photos) {
        if ([photoUrl isKindOfClass:[NSString class]]) {  // 数组为字符串时，封装photos为模型
            PYPhoto *photo = [PYPhoto photoWithUrl:photoUrl];
            [photosM addObject:photo];
        } else {
            [photosM addObject:photoUrl];
        }
    }
    _photos = photosM;
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
    self.contentOffset = CGPointZero;
    CGFloat width = size.width + self.originalX > PYScreenW ? PYScreenW - self.originalX : size.width;
    self.py_size = CGSizeMake(width, size.height);
}

- (void)setImages:(NSMutableArray *)images
{
    // 图片大于规定数字（取前九张）
    if (images.count > self.imageMaxCountWhenWillCompose) {
        NSRange range = NSMakeRange(0, self.imageMaxCountWhenWillCompose);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        images = [NSMutableArray arrayWithArray:[images objectsAtIndexes:set]];
    };
    
    _images = images;
    
    // 移除添加图片按钮
    [self.addImageButton removeFromSuperview];
    
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
    
    // 设置contentSize和 self.size
    // 取出size
    CGSize size = [self sizeWithPhotoCount:self.images.count photosState:self.photosState];
    self.contentSize = size;
    CGFloat width = size.width + self.originalX > PYScreenW ? PYScreenW - self.originalX : size.width;
    self.py_size = CGSizeMake(width, size.height);
    
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

#pragma mark - handle image

/** 点击添加图片调用此方法 */
- (void)addImageDidClicked
{
    // 发出添加图片的通知
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[PYAddImageDidClickedNotification] = self.images;
    NSNotification *notifaction = [[NSNotification alloc] initWithName:PYAddImageDidClickedNotification object:nil userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notifaction];
    
    if ([self.delegate respondsToSelector:@selector(photosView:didAddImageClickedWithImages:)]) {
        [self.delegate photosView:self didAddImageClickedWithImages:self.images];
    }
}

/** 添加图片按钮 */
- (UIButton *)addImageButton
{
    if (!_addImageButton) {
        UIButton *addImage = [[UIButton alloc] init];
        [addImage setBackgroundImage:PYAddImage forState:UIControlStateNormal];
        [addImage addTarget:self action:@selector(addImageDidClicked) forControlEvents:UIControlEventTouchUpInside];
        _addImageButton = addImage;
    }
    return _addImageButton;
}

/** 根据新的图片（未发布）刷新界面 */
- (void)reloadDataWithImages:(NSMutableArray *)images
{
    [self setImages:images];
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
    maxCount = self.photosMaxCol;
    if (state == PYPhotosViewStateDidCompose) { // 已经发布
        if (self.photos.count > 0 && self.layoutType == PYPhotosViewLayoutTypeFlow) {
           maxCount = count == 4 ? 2 : maxCount;
        }
        // 设置图片
    }else if (state == PYPhotosViewStateWillCompose){ // 未发布
        if (count < self.imageMaxCountWhenWillCompose) count ++;
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
    // 取消内边距
    self.contentInset = UIEdgeInsetsZero;
    NSInteger photosCount = self.photos.count > 0 ?  self.photos.count : self.images.count;
    NSInteger maxCol = self.photosMaxCol;
    
    if (self.photos.count == 4 && self.layoutType == PYPhotosViewLayoutTypeFlow && self.photosState == PYPhotosViewStateDidCompose) {
        maxCol = 2;
    }
    
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
    if (self.images.count < self.imageMaxCountWhenWillCompose && self.photosState == PYPhotosViewStateWillCompose) {
        [self addSubview:self.addImageButton];
        self.addImageButton.py_y = (self.images.count / maxCol) * (self.photoHeight + self.photoMargin);
        self.addImageButton.py_x = (self.images.count % maxCol) * (self.photoWidth + self.photoMargin);
        self.addImageButton.py_width = self.photoWidth;
        self.addImageButton.py_height = self.photoHeight;
        if (self.images.count == 0) { // 数组为空
            self.py_size = self.addImageButton.py_size;
        }
    }
}

@end
