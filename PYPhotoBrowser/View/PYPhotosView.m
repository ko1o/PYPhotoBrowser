//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import "PYPhotosView.h"
#import "PYPhotoView.h"
#import "PYPhoto.h"
#import "PYConst.h"
#import "PYPhotosViewController.h"
#import "PYPhotosReaderController.h"
#import "PYPhotosPreviewController.h"

@interface PYPhotosView()

/** 图片大小*/
@property (nonatomic, assign) CGSize photoSize;

/** 添加图片按钮*/
@property (nonatomic, strong) UIButton *addImageButton;

/** 记录scrollerView的x值 */
@property (nonatomic, assign) CGFloat originalX;

@end

static PYPhotosViewController *_handleController;
static NSInteger _photosViewCount;

@implementation PYPhotosView

@dynamic delegate;

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 只用一个控制器
        if (!_handleController) _handleController = [[PYPhotosViewController alloc] init];
        _photosViewCount++;
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
        self.imagesMaxCountWhenWillCompose = PYImagesMaxCountWhenWillCompose;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.autoRotateImage = YES;
        self.pageType = PYPhotosViewPageTypeControll;
        self.x = 0;
        self.pagingEnabled = NO;
        self.autoLayoutWithWeChatSytle = YES;
        self.showDuration = 0.5;
        self.hiddenDuration = 0.5;
    }
    return self;
}

+ (instancetype)photosView
{
    return [[self alloc] init];
}

+ (instancetype)photosViewWithThumbnailUrls:(NSArray *)thumbnailUrls originalUrls:(NSArray *)originalUrls
{
    PYPhotosView *photosView = [self photosView];
    photosView.thumbnailUrls = thumbnailUrls;
    photosView.originalUrls = originalUrls;
    return photosView;
}

+ (instancetype)photosViewWithImages:(NSMutableArray *)images
{
    PYPhotosView *photosView = [self photosView];
    photosView.images = images;
    return photosView;
}

+ (instancetype)photosViewWithThumbnailUrls:(NSArray *)thumbnailUrls originalUrls:(NSArray *)originalUrls layoutType:(PYPhotosViewLayoutType)type
{
    PYPhotosView *photosView = [self photosViewWithThumbnailUrls:thumbnailUrls originalUrls:originalUrls];
    photosView.layoutType = type;
    return photosView;
}

+ (instancetype)photosViewWithThumbnailUrls:(NSArray *)thumbnailUrls originalUrls:(NSArray *)originalUrls photosMaxCol:(NSInteger)maxCol
{
    PYPhotosView *photosView = [self photosViewWithThumbnailUrls:thumbnailUrls originalUrls:originalUrls];
    photosView.photosMaxCol = maxCol;
    return photosView;
}

- (void)dealloc
{
    _photosViewCount--;
    if (0 == _photosViewCount) { // 没有photosView了 可以销毁了
        _handleController = nil;
    }
}

// 返回最佳处理事件的view
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    // 判断这个点是否在subView上
    for (UIView *subView in self.subviews) {
        if (CGRectContainsPoint(subView.frame, point)) { // 触摸点在subView上
            return [super hitTest:point withEvent:event];
        }
    }
    // 触摸点不在subView，不处理点击事件
    return nil;
}

#pragma mark - setter方法
- (void)setAutoLayoutWithWeChatSytle:(BOOL)autoLayoutWithWeChatSytle
{
    _autoLayoutWithWeChatSytle = autoLayoutWithWeChatSytle;
    
    // 刷新
    self.photos = self.photos;
}

- (void)setImagesMaxCountWhenWillCompose:(NSInteger)imagesMaxCountWhenWillCompose
{
    _imagesMaxCountWhenWillCompose = imagesMaxCountWhenWillCompose;
    
    // 刷新图片个数
    self.images = self.images;
}

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
    if (self.photos.count) { // 已发布状态，有图片才刷新
        self.photos = self.photos;
    } else if (self.images.count) { // 未发布状态，刷新布局
        self.images = self.images;
    }
}

- (void)setPhotosUrl
{
    // 取出图片最多个数
    NSInteger maxPhotosCount = self.thumbnailUrls.count > self.originalUrls.count ? self.thumbnailUrls.count : self.originalUrls.count;
    NSMutableArray *photosM = [NSMutableArray array];
    for (NSInteger i = 0; i < maxPhotosCount; i++)
    {
        // 创建模型
        PYPhoto *photo = [[PYPhoto alloc] init];
        // 赋值
        photo.original_pic = i < self.originalUrls.count ? self.originalUrls[i] : nil;
        photo.thumbnail_pic = i < self.thumbnailUrls.count ? self.thumbnailUrls[i] : nil;
        // 添加模型
        [photosM addObject:photo];
    }
    // 刷新
    self.photos = photosM;
}

- (void)setOriginalUrls:(NSArray *)originalUrls
{
    _originalUrls = originalUrls;
    
    // 设置模型链接
    [self setPhotosUrl];
}

- (void)setThumbnailUrls:(NSArray *)thumbnailUrls
{
    _thumbnailUrls = thumbnailUrls;
    
    // 设置模型链接
    [self setPhotosUrl];
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    // 设置图片状态
    self.photosState = PYPhotosViewStateDidCompose;
    // 移除添加图片按钮
    [self.addImageButton removeFromSuperview];
    
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
    CGFloat width = size.width + self.py_x > PYScreenW ? PYScreenW - self.py_x : size.width;
    self.py_size = CGSizeMake(width, size.height);
}

- (void)setImages:(NSMutableArray *)images
{
    // 图片大于规定数字（取前九张）
    if (images.count > self.imagesMaxCountWhenWillCompose) {
        NSRange range = NSMakeRange(0, self.imagesMaxCountWhenWillCompose);
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
    CGFloat width = size.width + self.py_x > PYScreenW ? PYScreenW - self.py_x : size.width;
    self.py_size = CGSizeMake(width, size.height);
    
    // 刷新
    [self layoutSubviews];
}

- (void)setPhotoWidth:(CGFloat)photoWidth
{
    _photoWidth = photoWidth;
    
    // 刷新self的size
    if (self.photosState == PYPhotosViewStateWillCompose) { // 未发布
        self.images = self.images;
    } else if (self.photosState == PYPhotosViewStateDidCompose) { // 已发布
        self.photos = self.photos;
    }
    
    // 刷新布局
    [self layoutSubviews];
}

- (void)setPhotoHeight:(CGFloat)photoHeight
{
    _photoHeight = photoHeight;
    
    // 刷新self的size
    if (self.photosState == PYPhotosViewStateWillCompose) { // 未发布
        self.images = self.images;
    } else if (self.photosState == PYPhotosViewStateDidCompose) { // 已发布
        self.photos = self.photos;
    }
    
    // 刷新布局
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
    // 根据图片个数设置图片(最少一个)
    maxCount = self.photosMaxCol > 0 ? self.photosMaxCol : 1;
    if (state == PYPhotosViewStateDidCompose) { // 已经发布
        if (self.photos.count > 0 && self.layoutType == PYPhotosViewLayoutTypeFlow && self.autoLayoutWithWeChatSytle) {
           maxCount = count == 4 ? 2 : maxCount;
        }
    } else if (state == PYPhotosViewStateWillCompose){ // 未发布
        if (count < self.imagesMaxCountWhenWillCompose) count ++;
    }
    // 如果图片为一张，则图片的大小和photosView一致
    if (count == 1 && !CGSizeEqualToSize(self.bounds.size, CGSizeMake(self.photoMargin, self.photoMargin))) {
        return self.bounds.size;
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
    
    if (self.photos.count == 4 && self.layoutType == PYPhotosViewLayoutTypeFlow && self.photosState == PYPhotosViewStateDidCompose && self.autoLayoutWithWeChatSytle) {
        maxCol = 2;
    }
    // 当图片为一张时，图片大小和photosView一致
    if (self.photos.count == 1) {
        PYPhotoView *photoView = self.subviews[0];
        photoView.frame = self.bounds;
        self.contentSize = self.bounds.size;
        return;
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
    if (self.images.count < self.imagesMaxCountWhenWillCompose && self.photosState == PYPhotosViewStateWillCompose) {
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
