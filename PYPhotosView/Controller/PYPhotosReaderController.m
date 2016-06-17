//
//  PYPhotosReaderController.m
//  youzhu
//
//  Created by 谢培艺 on 16/2/18.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import "PYPhotosReaderController.h"
#import "PYPhotosView.h"
#import "PYPhotoView.h"
#import "PYPhoto.h"
#import "PYPhotoCell.h"
#import "PYConst.h"
#import "PYDALabeledCircularProgressView.h"
#import "UIImageView+WebCache.h"
@interface PYPhotosReaderController ()<UICollectionViewDelegateFlowLayout>
/** photoView */
@property (nonatomic, strong) PYPhotoView *photoView;

/** 所放大的window */
@property (nonatomic, strong) UIWindow *window;

/** 分页计数器 */
@property (nonatomic, strong) UIPageControl *pageControl;

/** 存储indexPaths的数组 */
@property (nonatomic, strong) NSMutableArray *indexPaths;

/** 记录当前屏幕状态 */
@property (nonatomic, assign) UIDeviceOrientation orientation;

@end

@implementation PYPhotosReaderController

#pragma mark - 懒加载
- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.py_width = self.view.py_width;
        _pageControl.py_y = self.view.py_height - 44;
        [self.view addSubview:_pageControl];
    }
    return _pageControl;
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
    [self.collectionView registerClass:[PYPhotoCell class] forCellWithReuseIdentifier:reuseIdentifier];
    // 支持分页
    self.collectionView.pagingEnabled = YES;
    self.collectionView.py_size = CGSizeMake(self.view.py_width, self.view.py_height);
    // 设置collectionView的width
    // 获取行间距
    CGFloat lineSpacing = ((UICollectionViewFlowLayout *)self.collectionViewLayout).minimumLineSpacing;
    self.collectionView.py_width += lineSpacing;
    // 设置collectionView的contenInset,增加范围
    if (PYIOS8) { // iOS8 会有预留20状态栏
        self.collectionView.contentInset = UIEdgeInsetsMake(-20, 0, 0, lineSpacing);
    } else if (PYIOS9) { // iOS 不需要预留状态栏
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, lineSpacing);
    }
    // 设置当前页面
    self.collectionView.contentOffset = CGPointMake(self.selectedPhotoView.tag * self.collectionView.py_width, self.collectionView.py_height);
    // 取消水平滚动条
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
}

+ (instancetype)readerController
{
    // 创建流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = PYPreviewPhotoSpacing;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    PYPhotosReaderController *readerVc = [[PYPhotosReaderController alloc] initWithCollectionViewLayout:layout];
    return readerVc;
}

// 呈现在某一个window上
- (void)showPhotosToWindow:(UIWindow *)window
{
    // 监听屏幕旋转通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];;
    
    // 显示窗口
    window.hidden = NO;
    window.backgroundColor = [UIColor blackColor];
    
    // 转移到窗口上
    PYPhotoView *copyView = [[PYPhotoView alloc] initWithImage:self.selectedPhotoView.image];
    
    // 转移坐标系
    copyView.frame = [[self.selectedPhotoView superview] convertRect:self.selectedPhotoView.orignalFrame toView:window];
    [window addSubview:copyView];
    self.window = window;
    self.beginView = copyView;
    
    // 变大
    // 获取选中的图片的大小
    CGSize imageSize = self.selectedPhotoView.image.size;
    // 设置个数
    self.pageControl.numberOfPages = self.selectedPhotoView.photos.count > 1 ? self.selectedPhotoView.photos.count : 0 ;
    self.pageControl.currentPage = self.selectedPhotoView.tag;
    
    // 添加控制器View
    self.collectionView.alpha = 0.0;
    [UIView animateWithDuration:0.5 animations:^{
        // 放大图片
        copyView.py_width = self.collectionView.py_width - ((UICollectionViewFlowLayout *)self.collectionViewLayout).minimumLineSpacing;
        copyView.py_height = PYScreenW * imageSize.height / imageSize.width;
        copyView.center = CGPointMake(PYScreenW * 0.5, PYScreenH * 0.5);
        self.collectionView.alpha = 1.0;
    } completion:^(BOOL finished) {
        window.backgroundColor = [UIColor clearColor];
        // 设置选中的windowView
        self.selectedPhotoView.windowView = copyView;
        // 隐藏
        copyView.hidden = YES;
        [window addSubview:self.collectionView];
        [window addSubview:self.pageControl];
    }];
    
    // 显示pageControll
    self.pageControl.hidden = NO;
}

// 隐藏图片
- (void)hiddenPhoto
{
    // 移除屏幕旋转通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 隐藏pageControll
    self.pageControl.hidden = YES;
    self.beginView.hidden = NO;
    
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

    // 移除self.collectionView的所有子控件
    [self.collectionView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 执行动画
    [UIView animateWithDuration:0.5 animations:^{
        // 恢复矩阵变换
        self.beginView.transform = CGAffineTransformIdentity;
        // 还原图片
        self.collectionView.alpha = 0.0;
        self.beginView.frame = beginFrame;
    } completion:^(BOOL finished) {
        self.beginView.hidden = YES;
        self.collectionView.hidden = YES;
        // 移除窗口
        self.window.hidden = YES;
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
        currentDevice.orientation == self.orientation) return;
    
    // 获取旋转角度
    CGFloat rotateAngle = 0;
    CGFloat width = PYScreenW;
    CGFloat height = PYScreenH;
    self.orientation = currentDevice.orientation;
    switch (currentDevice.orientation) { // 正常竖屏状态
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"倒屏");
            rotateAngle = M_PI;
            break;
        case UIDeviceOrientationPortrait:
            NSLog(@"正常竖屏");
            rotateAngle = 0;
            break;
        case UIDeviceOrientationLandscapeLeft:
            NSLog(@"横屏向左");
            rotateAngle = M_PI_2;
            width = PYScreenH;
            height= PYScreenW;
            break;
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"横屏向右");
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
    tempWindow.backgroundColor = [UIColor blackColor];
    [UIView animateWithDuration:0.5 animations:^{
        tempWindow.hidden = NO;
        self.window.transform = CGAffineTransformMakeRotation(rotateAngle);
        self.selectedPhotoView.windowView.hidden = NO;
        // 旋转过程中不允许交互
        self.window.userInteractionEnabled = NO;
        self.window.py_width = PYScreenW;
        self.window.py_height = PYScreenH;
        self.window.center = CGPointMake(PYScreenW * 0.5 , PYScreenH * 0.5);
        self.pageControl.py_centerX = width * 0.5;
        self.pageControl.py_y = height - 30;
        // 刷新数据
        [self.collectionView reloadData];
        // 设置当前页面
        self.collectionView.contentOffset = CGPointMake(self.selectedPhotoView.tag * self.collectionView.py_width, 0);
    } completion:^(BOOL finished) {
        self.window.userInteractionEnabled = YES;
        tempWindow.hidden = YES;
    }];
    
}

static NSString * const reuseIdentifier = @"Cell";

#pragma mark <UICollectionViewDataSource>
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
    PYPhoto *photo = self.selectedPhotoView.photos[indexPath.item];
    // 设置数据
    // 先设置photosView 再设置photo
    cell.photoView.photosView = self.selectedPhotoView.photosView;
    cell.photo = photo;
    // 返回cell
    return cell;
}

#pragma mark <UICollectionViewDelegate>
// 监听scrollView的滚动事件， 判断当前页数
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 发出通知
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[PYCollectionViewDidScrollNotification] = scrollView;
    [[NSNotificationCenter defaultCenter] postNotificationName:PYCollectionViewDidScrollNotification object:nil userInfo:userInfo];

    if (scrollView.contentOffset.x >= scrollView.contentSize.width || scrollView.contentOffset.x <= 0) return;
    
    // 计算页数
    NSInteger page = self.collectionView.contentOffset.x / self.collectionView.py_width + 0.5;
    self.pageControl.currentPage = page;
    
    // 取出photosView
    PYPhotosView *photosView = self.selectedPhotoView.photosView;
    self.selectedPhotoView = photosView.subviews[page];
    
    // 判断即将显示哪一张
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForItem:page inSection:0];
    PYPhotoCell *currentCell = (PYPhotoCell *)[self.collectionView cellForItemAtIndexPath:currentIndexPath];
    self.selectedPhotoView.windowView = currentCell.photoView;
}

#pragma mark <UICollectionViewDelegateFlowLayout>
// 设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.py_width - ((UICollectionViewFlowLayout *)collectionView.collectionViewLayout).minimumLineSpacing, collectionView.py_height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

@end
