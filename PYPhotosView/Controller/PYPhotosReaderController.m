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
@interface PYPhotosReaderController ()<UICollectionViewDelegateFlowLayout>
/** photoView */
@property (nonatomic, strong) PYPhotoView *photoView;

/** 所放大的window */
@property (nonatomic, strong) UIWindow *window;

/** 分页计数器 */
@property (nonatomic, strong) UIPageControl *pageControl;

/** 存储indexPaths的数组 */
@property (nonatomic, strong) NSMutableArray *indexPaths;

@end

@implementation PYPhotosReaderController

#pragma mark - 懒加载
- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.width = self.view.width;
        _pageControl.y = self.view.height - 44;
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
    // 设置collectionView的width
    // 获取行间距
    CGFloat lineSpacing = ((UICollectionViewFlowLayout *)self.collectionViewLayout).minimumLineSpacing;
    self.collectionView.width += lineSpacing;
    // 设置collectionView的contenInset,增加范围
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, lineSpacing);
    // 设置当前页面
    self.collectionView.contentOffset = CGPointMake(self.selectedPhotoView.tag * self.collectionView.width, self.collectionView.height);
    // 取消水平滚动条
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
}

+ (instancetype)readerController
{
    // 创建流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 40;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    PYPhotosReaderController *readerVc = [[PYPhotosReaderController alloc] initWithCollectionViewLayout:layout];
    return readerVc;
}

// 呈现在某一个window上
- (void)showPhotosToWindow:(UIWindow *)window
{
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
        copyView.width = self.collectionView.width - ((UICollectionViewFlowLayout *)self.collectionViewLayout).minimumLineSpacing;
        copyView.height = copyView.width * imageSize.height / imageSize.width;
        copyView.center = CGPointMake(PYScreenW * 0.5, PYScreenH * 0.5);
        self.collectionView.alpha = 1.0;
    } completion:^(BOOL finished) {
        window.backgroundColor = [UIColor clearColor];
        // 隐藏
        copyView.hidden = YES;
        [window addSubview:self.collectionView];
        [window addSubview:self.pageControl];
        // 设置选中的windowView
        self.selectedPhotoView.windowView = copyView;
    }];
    
    // 显示pageControll
    self.pageControl.hidden = NO;
}

// 隐藏图片
- (void)hiddenPhoto
{
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
    PYPhotoCell *cell  = [PYPhotoCell cellWithCollectionView:collectionView indexPath:indexPath];
    // 取出模型
    NSString  *photo = self.selectedPhotoView.photos[indexPath.item];
    // 设置数据
    // 先设置photosView 再设置photo
    cell.photoView.photosView = self.selectedPhotoView.photosView;
    cell.photo = photo;
    // 返回cell
    return cell;
}

#pragma mark <UICollectionViewDelegate>
// 监听collectionViewCell的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 发出缩小图片通知
    [[NSNotificationCenter defaultCenter] postNotificationName:PYSmallgImageDidClikedNotification object:nil];
}

// 监听scrollView的滚动事件， 判断当前页数
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 发出通知
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[PYCollectionViewDidScrollNotification] = scrollView;
    [[NSNotificationCenter defaultCenter] postNotificationName:PYCollectionViewDidScrollNotification object:nil userInfo:userInfo];

    if (scrollView.contentOffset.x >= scrollView.contentSize.width || scrollView.contentOffset.x < 0) return;
    
    // 计算页数
    NSInteger page = self.collectionView.contentOffset.x / self.collectionView.width + 0.5;
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
    return self.view.size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

@end
