//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import "PYPhotosPreviewController.h"
#import "PYPhotoView.h"
#import "PYPhotosView.h"
#import "PYPhotoCell.h"
#import "PYConst.h"
@interface PYPhotosPreviewController ()<UIActionSheetDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) BOOL isFirst;

/** 记录statusBar是否隐藏 */
@property (nonatomic, assign, getter=isStatusBarHidden) BOOL statusBarHidden;

/** 是否正在执行动画 */
@property (nonatomic, assign, getter=isAnimating) BOOL animating;

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
    // 用来判断是否偏移
    readerVc.isFirst = YES;
    
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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationController.navigationBar.backIndicatorImage = nil;
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(trashDidClicked)];
    
    NSString *title = [NSString stringWithFormat:@"%zd/%zd", self.selectedPhotoView.tag + 1, self.selectedPhotoView.images.count];
    self.title = title;
    
    // 监听通知
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(changeNavBarState) name:PYChangeNavgationBarStateNotification object:nil];
}

// 状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

// 状态栏隐藏动画
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationSlide;
}

// 状态栏是否隐藏
- (BOOL)prefersStatusBarHidden
{
    return self.isStatusBarHidden;
}

// 改变状态栏状态
- (void)changeNavBarState
{
    
    if (self.isAnimating) return;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.animating = YES;
        self.statusBarHidden = self.navigationController.navigationBar.py_y > 0;
        [self setNeedsStatusBarAppearanceUpdate];
        self.navigationController.navigationBar.py_y = self.statusBarHidden ? -self.navigationController.navigationBar.py_height : [UIApplication sharedApplication].statusBarFrame.size.height;
    } completion:^(BOOL finished) {
        self.animating = NO;
    }];
}

- (void)backAction
{
    // 刷新发布上的photosView
    self.selectedPhotoView.photosView.images = self.selectedPhotoView.images;
    
    if ([self.delegate respondsToSelector:@selector(photosPreviewController:didImagesChanged:)]) {
        [self.delegate photosPreviewController:self didImagesChanged:self.selectedPhotoView.photosView.images];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)trashDidClicked
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"要删除这张照片么" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
}

#pragma mark - <UIActionSheetDelegate>
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) { // 删除
        [MBProgressHUD py_showSuccess:@"已删除" toView:nil];// 计算页数
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSInteger page = self.collectionView.contentOffset.x / self.collectionView.py_width + 0.5;
            // 取出可见cell
            // 判断即将显示哪一张
            NSIndexPath *currentIndexPath = [NSIndexPath indexPathForItem:page inSection:0];
            PYPhotoCell *currentCell = (PYPhotoCell *)[self.collectionView cellForItemAtIndexPath:currentIndexPath];
            
            // 移除数组中的某个元素
            [self.selectedPhotoView.photosView.images removeObjectAtIndex:page];
            
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
                // 来到这里，证明
                [self backAction];
            };

        });
    }
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.selectedPhotoView.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PYPhotoCell *cell  = [PYPhotoCell cellWithCollectionView:collectionView indexPath:indexPath];
    cell.image = self.selectedPhotoView.images[indexPath.item];
    cell.photoView.isPreview = YES;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    
    // 隐藏状态栏
    if (!self.isStatusBarHidden) { // 没隐藏
        [self changeNavBarState];
    }
    
    self.title = [NSString stringWithFormat:@"%zd/%zd", self.selectedPhotoView.tag + 1,self.selectedPhotoView.photosView.images.count];
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
