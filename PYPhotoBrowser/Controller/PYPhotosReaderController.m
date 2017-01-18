//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import "PYPhotosReaderController.h"
#import "PYPhotosView.h"
#import "PYPhotoView.h"
#import "PYPhoto.h"
#import "PYPhotoCell.h"
#import "PYPhotoBrowserConst.h"
#import "PYProgressView.h"
#import "UIImageView+WebCache.h"
#import "PYPhotoBrowseView.h"

// 旋转角为90°或者270°
#define PYVertical (ABS(acosf(self.window.transform.a) - M_PI_2) < 0.01 || ABS(acosf(self.window.transform.a) - M_PI_2 * 3) < 0.01)

@interface PYPhotosReaderController ()<UICollectionViewDelegateFlowLayout>

/** 所放大的window */
@property (nonatomic, strong) PYPhotoBrowseView *window;

/** 分页计数器 */
@property (nonatomic, strong) UIPageControl *pageControl;
/** 分页计数（文本） */
@property (nonatomic, strong) UILabel *pageLabel;

/** 存储indexPaths的数组 */
@property (nonatomic, strong) NSMutableArray *indexPaths;
/** 记录当前屏幕状态 */
@property (nonatomic, assign) UIDeviceOrientation orientation;

/** 是否正在旋转 */
@property (nonatomic, assign, getter=isRotationg) BOOL rotating;
/** 是否正在缩放(图片点击) */
@property (nonatomic, assign, getter=isScaling) BOOL scaling;
/** 是否正在拖拽 */
@property (nonatomic, assign) BOOL dragging;

@end

@implementation PYPhotosReaderController

#pragma mark - 懒加载
- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        _pageControl = pageControl;
        _pageControl.py_width = self.view.py_width;
        _pageControl.py_y = self.view.py_height - 30;
    }
    _pageControl.hidden = self.selectedPhotoView.photosView.pageType == PYPhotosViewPageTypeLabel || _pageControl.numberOfPages > 9 || _pageControl.numberOfPages < 2;
    self.pageLabel.text = [NSString stringWithFormat:@"%zd / %zd", _pageControl.currentPage + 1, _pageControl.numberOfPages];
    return _pageControl;
}

- (UILabel *)pageLabel
{
    if (!_pageLabel) {
        UILabel *pageLabel = [[UILabel alloc] init];
        pageLabel.py_height = 44;
        pageLabel.py_width = self.view.py_width;
        pageLabel.py_y = self.view.py_height - 54;
        pageLabel.font = [UIFont boldSystemFontOfSize:16];
        pageLabel.textColor = [UIColor whiteColor];
        pageLabel.textAlignment = NSTextAlignmentCenter;
        _pageLabel = pageLabel;
    }
    // 判断是否显示_pageLabel
    // 取出指示类型
    _pageLabel.hidden = self.selectedPhotoView.photosView.pageType == PYPhotosViewPageTypeControll && _pageControl.numberOfPages < 10;
    return _pageLabel;
}

- (NSMutableArray *)indexPaths
{
    if (!_indexPaths) {
        _indexPaths = [NSMutableArray array];
    }
    return _indexPaths;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册cell
    [self.collectionView registerClass:[PYPhotoCell class] forCellWithReuseIdentifier:PYPhotoCellReuseIdentifier];
    // 支持分页
    self.collectionView.pagingEnabled = YES;
    self.collectionView.py_size = CGSizeMake(self.view.py_width, self.view.py_height);
    // 设置collectionView的width
    // 获取行间距
    CGFloat lineSpacing = ((UICollectionViewFlowLayout *)self.collectionViewLayout).minimumLineSpacing;
    self.collectionView.py_width += lineSpacing;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, lineSpacing);

    // 取消水平滚动条
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.contentOffset = CGPointMake(self.selectedPhotoView.tag * self.collectionView.py_width, 0);
}

+ (instancetype)readerController
{
    // 创建流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = PYPreviewPhotoSpacing;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    PYPhotosReaderController *readerVc = [[PYPhotosReaderController alloc] initWithCollectionViewLayout:layout];
    readerVc.dragging = NO;
    return readerVc;
}

// 呈现在某一个window上
- (void)showPhotosToWindow:(PYPhotoBrowseView *)window
{
    if ([window.delegate respondsToSelector:@selector(photoBrowseView:willShowWithImages:index:)]) {
        [window.delegate photoBrowseView:window willShowWithImages:window.images index:window.currentIndex];
    }
    // photosView
    PYPhotosView *photosView = self.selectedPhotoView.photosView;
    if ([photosView.delegate respondsToSelector:@selector(photosView:willShowWithPhotos:index:)]) {
        [photosView.delegate photosView:photosView willShowWithPhotos:photosView.photos index:self.selectedPhotoView.tag];
    }
    
    // 设置window
    self.window = window;
    
    // 监听屏幕旋转通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];;
    
    // 显示窗口
    self.view.hidden = YES;
    window.hidden = NO;
    window.backgroundColor = [UIColor blackColor];
    
    // 转移到窗口上
    PYPhotoView *copyView = [[PYPhotoView alloc] init];
    copyView.image = self.selectedPhotoView.image;
    // 转移坐标系
    copyView.frame = [[self.selectedPhotoView superview] convertRect:self.selectedPhotoView.orignalFrame toView:window];
    if (self.window.sourceImgageViews.count > 0) { // 用户已提供图片源
        // 获取图片源
        UIImageView *imgView = self.window.sourceImgageViews[self.window.currentIndex];
        // 设置坐标
        copyView.frame = [[imgView superview] convertRect:imgView.frame toView:window];
    }
    
    if (self.window.showFromView) {
        // 转移坐标系
        copyView.frame = [[self.window.showFromView superview] convertRect:self.window.showFromView.frame toView:window];
    }
    
    if (!CGRectEqualToRect(self.window.frameFormWindow, CGRectZero)) {
        copyView.frame = self.window.frameFormWindow;
    }
    [window addSubview:copyView];
    self.beginView = copyView;
    
    // 变大
    // 获取选中的图片的大小
    CGSize imageSize = self.selectedPhotoView.image.size;
    // 设置个数
    self.pageControl.numberOfPages = self.selectedPhotoView.photos.count;
    self.pageControl.currentPage = self.selectedPhotoView.tag;
    
    // 添加控制器View
    self.collectionView.alpha = 0.0;
    
    [UIView animateWithDuration:self.selectedPhotoView.photosView.showDuration animations:^{
        self.scaling = YES;
        // 放大图片
        copyView.py_width = self.collectionView.py_width - ((UICollectionViewFlowLayout *)self.collectionViewLayout).minimumLineSpacing;
        copyView.py_height = PYScreenW * imageSize.height / imageSize.width;
        copyView.center = CGPointMake(PYScreenW * 0.5, PYScreenH * 0.5);
        self.collectionView.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.scaling = NO;
        copyView.hidden = YES;
        window.backgroundColor = [UIColor clearColor];
        self.view.hidden = NO;
        [self.view addSubview:self.pageControl];
        [self.view addSubview:self.pageLabel];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self deviceOrientationDidChange]; // 判断当前屏幕方向
        });
        if ([self.window.delegate respondsToSelector:@selector(photoBrowseView:didShowWithImages:index:)]) {
            [self.window.delegate photoBrowseView:self.window didShowWithImages:self.window.images index:self.pageControl.currentPage];
        }
        if ([photosView.delegate respondsToSelector:@selector(photosView:didShowWithPhotos:index:)]) {
            [photosView.delegate photosView:photosView didShowWithPhotos:photosView.photos index:self.selectedPhotoView.tag];
        }
    }];
    
    // 是否隐藏pageControl
    self.pageControl.hidden = self.pageControl.numberOfPages < 2;
}

- (void)dealloc
{
    [self.window.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (self.selectedPhotoView.photosView.photosState == PYPhotosViewStateDidCompose) {
        for (PYPhotoView *photoView in self.selectedPhotoView.photosView.subviews) {
            photoView.windowView = nil; // 清空窗口的photoView
        }
        // 清除选中photoView的窗口view
        self.selectedPhotoView.windowView = nil;
    }
}

// 隐藏图片
- (void)hiddenPhoto
{
    if ([self.window.delegate respondsToSelector:@selector(photoBrowseView:willHiddenWithImages:index:)]) {
        [self.window.delegate photoBrowseView:self.window willHiddenWithImages:self.window.images index:self.pageControl.currentPage];
    }
    // photosView
    PYPhotosView *photosView = self.selectedPhotoView.photosView;
    if ([photosView.delegate respondsToSelector:@selector(photosView:willHiddenWithPhotos:index:)]) {
        [photosView.delegate photosView:photosView willHiddenWithPhotos:photosView.photos index:self.pageControl.currentPage];
    }
    
    // 移除屏幕旋转通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 隐藏pageControl
    self.pageControl.hidden = YES;
    self.beginView.hidden = NO;
    self.pageLabel.hidden = YES;
    
    // 先转移坐标系
    self.selectedPhotoView.windowView.frame = [self.selectedPhotoView.windowView convertRect:self.selectedPhotoView.windowView.bounds toView:self.window];
    
    // 移除前一个view
    [self.beginView removeFromSuperview];
    
    if (self.selectedPhotoView.windowView) { // 如果有windowView,证明图片滚动了，需要移除刚开始的beginView
        // 添加当前windowView
        self.beginView = self.selectedPhotoView.windowView;
    }
    [self.window addSubview:self.beginView];
    // 计算原始窗口的frame
    // 转移坐标系
    CGRect beginFrame = [[self.selectedPhotoView superview] convertRect:self.selectedPhotoView.orignalFrame toView:self.window];
    if (self.window.sourceImgageViews.count > 0) { // 使用快速浏览图片功能
        // 取出当前图片的imageView
        UIImageView *imageView = self.window.sourceImgageViews[self.pageControl.currentPage];
        beginFrame = [[imageView superview] convertRect:imageView.frame toView:self.window];
    }
    if (self.window.hiddenToView) {
        // 转移坐标系
        beginFrame = [[self.window.hiddenToView superview] convertRect:self.window.hiddenToView.frame  toView:self.window];
    }
    if (!CGRectEqualToRect(self.window.frameToWindow, CGRectZero)) {
        beginFrame = self.window.frameToWindow;
    }

    // 移除self.collectionView的所有子控件
    [self.collectionView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 刷新图片
    [self.beginView.photosView setPhotos:self.selectedPhotoView.photosView.photos];
    
    // 执行动画
    [UIView animateWithDuration:self.selectedPhotoView.photosView.hiddenDuration animations:^{
        self.scaling = YES;
        // 还原图片
        self.collectionView.alpha = 0.0;
        // 恢复矩阵变换
        self.beginView.transform = CGAffineTransformIdentity;
        self.beginView.frame = beginFrame;
        if (!CGRectIntersectsRect(beginFrame, [UIScreen mainScreen].bounds)) { // 超出范围，不缩放，直接渐变消失
            self.beginView.hidden = YES;
        }
    } completion:^(BOOL finished) {
        self.scaling = NO;
        self.beginView.hidden = YES;
        self.collectionView.hidden = YES;
        if ([self.window.delegate respondsToSelector:@selector(photoBrowseView:didHiddenWithImages:index:)]) {
            [self.window.delegate photoBrowseView:self.window didHiddenWithImages:self.window.images index:self.pageControl.currentPage];
        }
        if ([photosView.delegate respondsToSelector:@selector(photosView:didHiddenWithPhotos:index:)]) {
            [photosView.delegate photosView:photosView didHiddenWithPhotos:photosView.photos index:self.selectedPhotoView.tag];
        }
        // 去除根控制器
        self.window.rootViewController = nil;
        // 移除窗口
        self.window.hidden = YES;
        // 移除self.window.photosView
        self.window.photosView = nil;
    }];
}

// 监听屏幕旋转
- (void)deviceOrientationDidChange
{
    // 获取当前设备
    UIDevice *currentDevice = [UIDevice currentDevice];
    // 设备方向位置，面朝上，面朝下
    if (currentDevice.orientation == UIDeviceOrientationUnknown ||
        currentDevice.orientation == UIDeviceOrientationFaceUp ||
        currentDevice.orientation == UIDeviceOrientationFaceDown ||
        currentDevice.orientation == self.orientation ||
        self.isRotationg ||
        self.window.autoRotateImage == NO) return;
    
    // 获取旋转角度
    CGFloat rotateAngle = 0;
    CGFloat width = PYScreenW;
    CGFloat height = PYScreenH;
    self.orientation = currentDevice.orientation;
    switch (currentDevice.orientation) { // 当前屏幕状态
        case UIDeviceOrientationPortraitUpsideDown: // 倒屏
            rotateAngle = M_PI;
            break;
        case UIDeviceOrientationPortrait: // 正常竖屏
            rotateAngle = 0;
            break;
        case UIDeviceOrientationLandscapeLeft: // 横屏向左
            rotateAngle = M_PI_2;
            width = PYScreenH;
            height= PYScreenW;
            break;
        case UIDeviceOrientationLandscapeRight: // 横屏向右
            rotateAngle = -M_PI_2;
            width = PYScreenH;
            height= PYScreenW;
            break;
        default:
            break;
    }
    
    // 判断即将显示哪一张
    // 执行旋转动画
    __block UIWindow *tempWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    tempWindow.windowLevel = UIWindowLevelStatusBar;
    // 自动调节宽高
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    tempWindow.backgroundColor = [UIColor blackColor];
    // 记录刚开始的旋转
    PYPhotoView *windowView = self.selectedPhotoView.windowView;
    CGAffineTransform temp = CGAffineTransformScale(windowView.transform, 1 / windowView.scale, 1 / windowView.scale);
    // 获取角度
    CGFloat originalAngle = acosf(temp.a);
    if (ABS(asinf(windowView.transform.b) + M_PI_2) < 0.01) { // 旋转270°
        originalAngle += M_PI;
    }
    windowView.transform = CGAffineTransformScale(windowView.transform, 1 / windowView.scale, 1 / windowView.scale);
    // 获取旋转角度
    UIRotationGestureRecognizer *rotateGR = [[UIRotationGestureRecognizer alloc] init];
    [rotateGR setValue:@(UIGestureRecognizerStateBegan) forKeyPath:@"state"];
    rotateGR.rotation = -originalAngle;
    [self.selectedPhotoView.windowView photoDidRotation:rotateGR];
    windowView.rotationGesture = NO;
    // 恢复倍数
    windowView.scale = 1.0;
    [UIView animateWithDuration:0.5 animations:^{
        // 正在旋转
        self.rotating = YES;
        // 禁止与用户交互
        self.window.userInteractionEnabled = NO;
        // 显示临时黑色背景窗口
        tempWindow.hidden = NO;
        self.window.transform = CGAffineTransformMakeRotation(rotateAngle);
        self.window.py_width = PYScreenW;
        self.window.py_height = PYScreenH;
        self.window.center = CGPointMake(PYScreenW * 0.5 , PYScreenH * 0.5);
        self.view.frame = self.window.bounds;
        self.pageControl.py_centerX = width * 0.5;
        self.pageControl.py_y = height - 30;
        self.pageLabel.py_centerX = width * 0.5;
        self.pageLabel.py_y = height - 54;
        // 刷新数据
        [self.collectionView reloadData];
        NSInteger photosCount = self.selectedPhotoView.photos.count;
        self.collectionView.contentSize = CGSizeMake(self.collectionView.py_width * photosCount, self.collectionView.py_height);
        self.collectionView.contentOffset = CGPointMake(self.selectedPhotoView.tag * self.collectionView.py_width, 0);
    } completion:^(BOOL finished) {
        self.rotating = NO;
        self.window.userInteractionEnabled = YES;
        tempWindow.hidden = YES;
    }];
}



#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.selectedPhotoView.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 创建cell
    PYPhotoCell *cell = [PYPhotoCell cellWithCollectionView:collectionView indexPath:indexPath];
    // 取出模型
    PYPhoto *photo = self.selectedPhotoView.photosView.photos[indexPath.item];
    // 设置数据
    // 先设置photosView 再设置photo
    cell.photoView.photosView = self.selectedPhotoView.photosView;
    cell.photo = photo;
    self.selectedPhotoView.windowView = cell.photoView;
    cell.photoView.delegate = self.window;
    // 返回cell
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.dragging = YES;
}

// 监听scrollView的滚动事件， 判断当前页数
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x != self.selectedPhotoView.tag * self.collectionView.py_width && PYIOS8 && !self.dragging) { // 修复在iOS8系统下，scrollView.contentOffset被系统又初始化的BUG
        scrollView.contentOffset = CGPointMake(self.selectedPhotoView.tag * self.collectionView.py_width, 0);
    }

    // 发出通知
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[PYCollectionViewDidScrollNotification] = scrollView;
    [[NSNotificationCenter defaultCenter] postNotificationName:PYCollectionViewDidScrollNotification object:nil userInfo:userInfo];
    if (scrollView.contentOffset.x >= scrollView.contentSize.width || scrollView.contentOffset.x <= 0 || self.rotating) return;
    // 计算页数
    NSInteger page = self.collectionView.contentOffset.x / self.collectionView.py_width + 0.5;
    // 避免数组越界
    self.pageControl.currentPage = page >= self.pageControl.numberOfPages ? self.pageControl.numberOfPages - 1 : page;
    // 取出photosView
    PYPhotosView *photosView = self.selectedPhotoView.photosView;
    if (page <= (photosView.subviews.count - 1))
        self.selectedPhotoView = photosView.subviews[page];
    
    // 判断即将显示哪一张
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForItem:page inSection:0];
    PYPhotoCell *currentCell = (PYPhotoCell *)[self.collectionView cellForItemAtIndexPath:currentIndexPath];
    self.selectedPhotoView.windowView = currentCell.photoView;
}

#pragma mark - UICollectionViewDelegateFlowLayout
// 设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemHeight = PYVertical ? PYScreenW : PYScreenH;
    self.collectionView.py_height = itemHeight;
    return CGSizeMake(collectionView.py_width - ((UICollectionViewFlowLayout *)collectionView.collectionViewLayout).minimumLineSpacing, itemHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

@end
