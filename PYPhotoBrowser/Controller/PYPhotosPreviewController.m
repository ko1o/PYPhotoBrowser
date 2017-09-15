//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import "PYPhotosPreviewController.h"
#import "PYPhotoView.h"
#import "PYPhotosView.h"
#import "PYPhotoCell.h"
#import "PYPhoto.h"
#import "PYPhotoBrowserConst.h"
#import "UIImageView+WebCache.h"

@interface PYPhotosPreviewController ()<UIActionSheetDelegate, UICollectionViewDelegateFlowLayout>

/** 是否是第一张 */
@property (nonatomic, assign) BOOL isFirst;

/** 记录statusBar是否隐藏 */
@property (nonatomic, assign, getter=isStatusBarHidden) BOOL statusBarHidden;
/** 是否正在执行动画 */
@property (nonatomic, assign, getter=isNavBarAnimating) BOOL navBarAnimating;

@end

@implementation PYPhotosPreviewController

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithCollectionViewLayout:layout]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

+ (instancetype)previewController
{
    // 创建流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置间距
    layout.minimumLineSpacing = PYPreviewPhotoSpacing;
    layout.minimumInteritemSpacing = 0;
    // 设置滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 创建预览控制器
    PYPhotosPreviewController *readerVc = [[PYPhotosPreviewController alloc] initWithCollectionViewLayout:layout];
    
    readerVc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:readerVc action:@selector(backAction)];
    readerVc.navigationController.navigationBar.backIndicatorImage = nil;
    readerVc.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    readerVc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:readerVc action:@selector(trashDidClicked)];
    
    return readerVc;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.isFirst) {
        self.collectionView.contentOffset = CGPointMake(self.selectedPhotoView.tag * self.collectionView.py_width, 0);
        self.isFirst = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *title = [NSString stringWithFormat:@"%zd/%zd", self.selectedPhotoView.tag + 1, self.selectedPhotoView.images.count];
    self.title = title;
    // 用来判断是否偏移
    self.isFirst = YES;
    
    // 监听通知
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(changeNavBarState) name:PYChangeNavgationBarStateNotification object:nil];
}

/** 返回状态栏style */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

/* 返回状态栏隐藏动画模式 */
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationSlide;
}

/* 返回状态栏是否隐藏 */
- (BOOL)prefersStatusBarHidden
{
    return self.isStatusBarHidden;
}

/* 改变状态栏状态 */
- (void)changeNavBarState
{
    // 如果正在执行动画，直接返回
    if (self.isNavBarAnimating) return;
    CGFloat duration = 0.5;
    [UIView animateWithDuration:duration animations:^{
        self.navBarAnimating = YES;
        self.statusBarHidden = self.navigationController.navigationBar.py_y > 0;
        [self setNeedsStatusBarAppearanceUpdate];
        self.navigationController.navigationBar.py_y = self.statusBarHidden ? -self.navigationController.navigationBar.py_height : [UIApplication sharedApplication].statusBarFrame.size.height;
    } completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.navBarAnimating = NO;
    });
}

/** 关闭 */
- (void)close
{
    [self backAction];
}

/** 返回按钮点击 */
- (void)backAction
{
    // 刷新发布上的photosView
    self.selectedPhotoView.photosView.images = self.selectedPhotoView.images;
    // 调用代理实现
    if ([self.delegate respondsToSelector:@selector(photosPreviewController:didImagesChanged:)]) {
        [self.delegate photosPreviewController:self didImagesChanged:self.selectedPhotoView.photosView.images];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** 点击删除照片 */
- (void)trashDidClicked
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"要删除这张照片么" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
}

// 删除图片
- (void)deleteImage
{
    NSInteger page = self.collectionView.contentOffset.x / self.collectionView.py_width + 0.5;
    // 取出可见cell
    // 判断即将显示哪一张
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForItem:page inSection:0];
    PYPhotoCell *currentCell = (PYPhotoCell *)[self.collectionView cellForItemAtIndexPath:currentIndexPath];
    
    // 移除数组中的某个元素
    [self.selectedPhotoView.photosView.images removeObjectAtIndex:page];
    [self.selectedPhotoView.photosView refreshContentSizeWithPhotoCount:self.selectedPhotoView.photosView.images.count];
    // 移除cell
    [currentCell removeFromSuperview];
    // 刷新cell
    [self.collectionView reloadData];
    
    NSUInteger currentPage = self.selectedPhotoView.tag;
    currentPage = self.selectedPhotoView.tag <= 1 ? 1 : self.selectedPhotoView.tag;
    // 往前移一张
    self.collectionView.contentOffset = CGPointMake((currentPage - 1) * self.collectionView.py_width, 0);
    // 刷新标题
    self.title = [NSString stringWithFormat:@"%zd/%zd", currentPage,self.selectedPhotoView.photosView.images.count];
    
    if (self.selectedPhotoView.photosView.images.count == 0) {
        // 来到这里说明没有图片，退出预览
        [self backAction];
    };
    
    // 代理
    if ([self.selectedPhotoView.photosView.delegate respondsToSelector:@selector(photosView:didDeleteImageIndex:)]) { // 自定义 自己管理删除事件
        [self.selectedPhotoView.photosView.delegate photosView:self.selectedPhotoView.photosView didDeleteImageIndex:page];
    }
}

#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) { // 删除
        [MBProgressHUD py_showSuccess:@"已删除" toView:self.view];// 计算页数
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 删除图片
            [self deleteImage];
        });
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.selectedPhotoView.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PYPhotoCell *cell  = [PYPhotoCell cellWithCollectionView:collectionView indexPath:indexPath];
    id image = self.selectedPhotoView.images[indexPath.item];
    if ([image isKindOfClass:[UIImage class]]) {
        cell.image = image;
    } else if ([image isKindOfClass:[PYPhoto class]]) {
        cell.photo = (PYPhoto*)image;
    } else if ([image isKindOfClass:[NSString class]]) {
        [cell.photoView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:PYPlaceholderImage];
    }
    
    cell.photoView.isPreview = YES;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    /* 不知道什么作用，有 bug (contentScrollView.py_height 和 contentScrollView.contentOffset 这两句赋值语句会导致放大图片后滑动出问题)
    // 设置contentScrollView
    UIScrollView *contentScrollView = self.selectedPhotoView.windowView.photoCell.contentScrollView;
    contentScrollView.py_height = contentScrollView.py_height > PYScreenH ? PYScreenH : contentScrollView.py_height;
    contentScrollView.contentOffset = CGPointZero;
    contentScrollView.scrollEnabled = YES;
    contentScrollView.center = CGPointMake(PYScreenW * 0.5, PYScreenH * 0.5);
    */
    // 隐藏状态栏
    if (!self.isStatusBarHidden) [self changeNavBarState];
    // 设置标题
    self.title = [NSString stringWithFormat:@"%zd/%zd", self.selectedPhotoView.tag + 1, self.selectedPhotoView.photosView.images.count];
}

#pragma mark <UICollectionViewDelegateFlowLayout>
// 设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return PYScreenSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

@end
