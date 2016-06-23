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
@interface PYPhotosPreviewController ()<UIActionSheetDelegate>

@property (nonatomic, assign) BOOL isFirst;

@end

@implementation PYPhotosPreviewController

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

+ (instancetype)previewController
{
    // 创建流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置间距
    layout.minimumLineSpacing = 0;
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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation_back"] style:UIBarButtonItemStylePlain target:self action:@selector(BackAction)];
    self.navigationController.navigationBar.backIndicatorImage = nil;
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(trashDidClicked)];
    
    NSString *title = [NSString stringWithFormat:@"%zd/%zd", self.selectedPhotoView.tag + 1, self.selectedPhotoView.images.count];
    self.title = title;
    
    // 监听通知
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(changeNavBarState) name:PYChangeNavgationBarStateNotification object:nil];
}

- (void)changeNavBarState
{
    if(self.navigationController.navigationBar.py_y < 0){ // 隐藏
        [UIView animateWithDuration:0.5 animations:^{
//            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
            self.navigationController.navigationBar.py_y = [UIApplication sharedApplication].statusBarFrame.size.height;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
//            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
            self.navigationController.navigationBar.py_y = - self.navigationController.navigationBar.py_height;
        }];
    }
}

- (void)BackAction
{
    if ([self.delegate respondsToSelector:@selector(photosPreviewController:didImagesChanged:)]) {
        [self.delegate photosPreviewController:self didImagesChanged:self.selectedPhotoView.photosView.images];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
            
            // 往前移一张
            self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x - self.collectionView.py_width, 0);
            
            // 刷新cell
            [self.collectionView reloadData];
            
            NSUInteger currentPage = 0;
            currentPage = self.selectedPhotoView.tag == 1 ? 1 : page - 1;
            
            // 刷新标题
            self.title = [NSString stringWithFormat:@"%zd/%zd", currentPage,self.selectedPhotoView.photosView.images.count];
            
            if(self.selectedPhotoView.photosView.images.count == 0) {
                // 来到这里，证明
                [self BackAction];
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
    
    if (scrollView.contentOffset.x >= scrollView.contentSize.width || scrollView.contentOffset.x < 0) return;
    // 计算页数
    NSInteger page = self.collectionView.contentOffset.x / self.collectionView.py_width + 0.5;
    // 取出photosView
    PYPhotosView *photosView = self.selectedPhotoView.photosView;
    self.selectedPhotoView = photosView.subviews[page];
    // 判断即将显示哪一张
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForItem:page inSection:0];
    PYPhotoCell *currentCell = (PYPhotoCell *)[self.collectionView cellForItemAtIndexPath:currentIndexPath];
    
    self.selectedPhotoView.windowView = currentCell.photoView;
    self.title = [NSString stringWithFormat:@"%zd/%zd", self.selectedPhotoView.tag + 1,self.selectedPhotoView.photosView.images.count];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.navigationController.navigationBar.py_y < 0){ // 隐藏
        [UIView animateWithDuration:0.5 animations:^{
            //            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
            self.navigationController.navigationBar.py_y = [UIApplication sharedApplication].statusBarFrame.size.height;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            //            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
            self.navigationController.navigationBar.py_y = - self.navigationController.navigationBar.py_height;
        }];
    }
}

@end
