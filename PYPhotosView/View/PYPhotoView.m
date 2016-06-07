//
//  PYPhotoView.m
//  新浪微博
//
//  Created by 谢培艺 on 15/12/16.
//  Copyright © 2015年 iphone5solo. All rights reserved.
//

#import "PYPhotoView.h"
#import "UIImageView+WebCache.h"
#import "PYPhoto.h"
#import "PYPhotosView.h"
#import "PYConst.h"
#import "PYPhotosReaderController.h"
#import "PYPhotoCell.h"
#import "DALabeledCircularProgressView.h"
@interface PYPhotoView ()<UIActionSheetDelegate, UIGestureRecognizerDelegate>

/** gif图片 */
@property (nonatomic, weak) UIImageView *gifImageView;

/** 单击手势 */
@property (nonatomic, weak) UIGestureRecognizer *singleTap;

/** 原始锚点 */
@property (nonatomic, assign) CGPoint originAnchorPoint;

@end

@implementation PYPhotoView

- (instancetype)init
{
    if (self = [super init]) {
        // 运行与用户交互
        self.userInteractionEnabled = YES;
        
        // photoView添加单击手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidClicked:)];
        [self addGestureRecognizer:singleTap];
        self.singleTap = singleTap;
        
        // 监听通知
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(collectionViewDidScroll:) name:PYCollectionViewDidScrollNotification object:nil];
        
        // 添加加载进度指示器
        DALabeledCircularProgressView *progressView = [[DALabeledCircularProgressView alloc] init];
        progressView.size = CGSizeMake(100, 100);
        [self addSubview:progressView];
        self.progressView = progressView;
        
        // 设置原始锚点
        self.originAnchorPoint = self.layer.anchorPoint;
    }
    return self;
}

- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 拦截当前状态(是否是在预览)
- (void)setIsBig:(BOOL)isBig
{
    _isBig = isBig;
    if (isBig) { // 预览状态，支持双击手势，支持加载进度指示器
        // 添加双击手势
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidDoubleClicked:)];
        [doubleTap setNumberOfTapsRequired:2];
        [self addGestureRecognizer:doubleTap];
        // 单击双击共存时，避免双击失效
        [self.singleTap requireGestureRecognizerToFail:doubleTap];
    }
}

// 监听transform
- (void)setTransform:(CGAffineTransform)transform
{
    [super setTransform:transform];
    if (self.width >= PYScreenW) {
        // 修改contentScrollView的属性
        UIScrollView *contentScrollView = self.photoCell.contentScrollView;
        contentScrollView.scrollEnabled = YES;
        contentScrollView.height = self.height < PYScreenH ? self.height : PYScreenH;
        contentScrollView.width = PYScreenW;
        contentScrollView.contentSize = self.size;
        contentScrollView.center = CGPointMake(PYScreenW * 0.5, PYScreenH * 0.5);
        contentScrollView.contentInset = UIEdgeInsetsMake(-self.y, -self.x, self.y, self.x);
        contentScrollView.contentOffset = CGPointMake((contentScrollView.contentSize.width  - contentScrollView.width) * self.layer.anchorPoint.x - contentScrollView.contentInset.left, (contentScrollView.contentSize.height  - contentScrollView.height) * self.layer.anchorPoint.y - contentScrollView.contentInset.top);
    } else {
        self.photoCell.contentScrollView.scrollEnabled = NO;
    }
}

- (void)setPhotoCell:(PYPhotoCell *)photoCell
{
    _photoCell = photoCell;
    if (self.isBig) {
        // photoCell添加单击手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidClicked:)];
        [photoCell addGestureRecognizer:singleTap];
        
        // photoCell添加双击手势
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidDoubleClicked:)];
        [doubleTap setNumberOfTapsRequired:2];
        [photoCell addGestureRecognizer:doubleTap];
        
        // photoCell单击双击共存时，单击失效
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        // photoCell添加长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidLongPress:)];
        [photoCell addGestureRecognizer:longPress];
        
        // photoCell添加捏合手势
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidPinch:)];
        [photoCell addGestureRecognizer:pinch];
        
        // photoCell添加旋转手势
        UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(photoDidRotation:)];
        [photoCell addGestureRecognizer:rotation];
    }
}

- (void)setImage:(UIImage *)image
{
    CGFloat height = PYScreenW * image.size.height / image.size.width;
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    // 设置进度条
    self.progressView.hidden = !self.isBig;
    if (height > PYScreenH) { // 长图
        if (self.isBig) { // 预览状态
            self.size = CGSizeMake(PYScreenW, PYScreenW * image.size.height / image.size.width);
        } else {
            self.size = CGSizeMake(PYScreenW, PYScreenH);
            // 显示最上面的
            UIGraphicsBeginImageContextWithOptions(self.size,YES, 0.0);
            // 绘图
            CGFloat width = self.width;
            CGFloat height = width * image.size.height / image.size.width;
            [image drawInRect:CGRectMake(0, 0, width, height)];
            // 保存图片
            image = UIGraphicsGetImageFromCurrentImageContext();
            // 关闭上下文
            UIGraphicsEndImageContext();
        }
    }
    [super setImage:image];
    
    self.progressView.center = CGPointMake(PYPlaceholderImage.size.width * 0.5, PYPlaceholderImage.size.height * 0.5);
    self.size = self.isBig ? CGSizeMake(PYScreenW, height) : self.image.size;
}

// 旋转手势
- (void)photoDidRotation:(UIRotationGestureRecognizer *)rotation
{

}

// 捏合手势
- (void)imageDidPinch:(UIPinchGestureRecognizer *)pinch
{
    // 当手势开始
    if (pinch.state == UIGestureRecognizerStateBegan) {
        // 设置新的锚点
        [self setAnchorPointBaseOnGestureRecognizer:pinch];
    } else if (pinch.state == UIGestureRecognizerStateFailed || pinch.state == UIGestureRecognizerStateCancelled) {
        // 恢复锚点
        self.layer.anchorPoint = CGPointMake(0.5, 0.5);
    }
    
    if (self.isBig) {  // 预览状态
        self.transform = CGAffineTransformScale(self.transform, pinch.scale, pinch.scale);
        // 复位
        pinch.scale = 1;
    };
    
    if (pinch.state == UIGestureRecognizerStateEnded) { // 手势结束
        if (!self.isBig) { // 预览状态
            [self imageDidClicked:nil];
            return;
        }
        // 判断是否缩小
        UIWindow *lastWindow = [[UIApplication sharedApplication].windows lastObject];
        CGFloat scale = 1;
        if (self.width < lastWindow.width) { // 缩小了
            // 放大
            scale = lastWindow.width / self.width;
        } else { // 放大了
            if (self.width > lastWindow.width * PYPreviewPhotoMaxScale) { // 最大放大3倍
                scale = lastWindow.width * PYPreviewPhotoMaxScale / self.width;
            }
        }
        // 复位
        [UIView animateWithDuration:0.25  delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.transform = CGAffineTransformScale(self.transform,scale,scale);
        } completion:^(BOOL finished) {
            // 恢复锚点
            [self setAnchorPoint:CGPointMake(0.5, 0.5) forView:self];
        }];
    }
}

// 长按手势
- (void)imageDidLongPress:(UITapGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateEnded) {
        // 判断图片是否是预览状态(如果不是预览状态，手势无效)
        if (!self.isBig) { // 长按转为单击
            [self imageDidClicked:nil];
            return;
        };
    }
    if (longPress.state == UIGestureRecognizerStateBegan) {  // 长按结束
        if (self.isBig) { // 预览状态
            // 跳出提示
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到相册", @"发送给朋友", nil];
            sheet.delegate = self;
            [sheet showInView:self.window];
        }
    }
}

// 双击手势（只有图片在预览状态时才支持）
- (void)imageDidDoubleClicked:(UITapGestureRecognizer *)singleTap
{
    // 修改锚点
    [self setAnchorPointBaseOnGestureRecognizer:singleTap];
    if (self.size.width <= PYScreenW) { // 没放大
        [UIView animateWithDuration:0.25  delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{ // 双击放大两倍
            CGFloat scale = PYPreviewPhotoMaxScale;
            // 恢复siz
            self.transform = CGAffineTransformScale(self.transform,scale,scale);
        } completion:^(BOOL finished) {
            // 恢复锚点
            [self setAnchorPoint:CGPointMake(0.5, 0.5) forView:self];
        }];
    } else {
      [UIView animateWithDuration:0.25  delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{ // 双击恢复
          // 放大
          self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            // 恢复锚点
            [self setAnchorPoint:CGPointMake(0.5, 0.5) forView:self];
        }];
    }
}

// 单击手势
- (void)imageDidClicked:(UITapGestureRecognizer *)sender
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    if (self.photosView.photosState == PYPhotosViewStateDidCompose) { // 已发布
        if (!self.isBig) { // 放大
            // 遍历所有photoFrame记录原始frame
            for (PYPhotoView *photoView in self.photosView.subviews) {
                photoView.orignalFrame = photoView.frame;
            }
            // 发出通知
            userInfo[PYBigImageDidClikedNotification] = self;
            NSNotification *notification = [[NSNotification alloc] initWithName:PYBigImageDidClikedNotification object:sender userInfo:userInfo];
            [center postNotification:notification];
        } else { // 缩小
            // 不可以双击
            userInfo[PYSmallgImageDidClikedNotification] = self;
            NSNotification *notification = [[NSNotification alloc] initWithName:PYSmallgImageDidClikedNotification object:sender userInfo:userInfo];
            [center postNotification:notification];
        }
    } else if (self.photosView.photosState == PYPhotosViewStateWillCompose) { // 未发布
        if (self.isPreview) { // 正在预览
                NSNotification *notifaction = [[NSNotification alloc] initWithName:PYChangeNavgationBarStateNotification object:sender userInfo:userInfo];
                [center postNotification:notifaction];
        } else { // 将要预览
            // 进入预览界面
            userInfo[PYPreviewImagesDidChangedNotification] = self;
            NSNotification *notifaction = [[NSNotification alloc] initWithName:PYPreviewImagesDidChangedNotification object:sender userInfo:userInfo];
            [center postNotification:notifaction];
        }
    }
}

- (UIImageView *)gifImageView
{
    if (!_gifImageView) {
        UIImageView *gifView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PYPhotosView.bundle/common-gif"]];
        _gifImageView = gifView;
        [self addSubview:gifView];
    }
    return _gifImageView;
}

// 设置图片（图片来自网络）
- (void)setPhoto:(NSString *)photo
{
    _photo = photo;
    // 设置图片
    NSURL *imgUrl = [NSURL URLWithString:photo];
    [self sd_setImageWithURL:imgUrl placeholderImage:PYPlaceholderImage];

    if ([photo.lowercaseString hasSuffix:@"gif"]) { // 以gif或者GIF结尾的图片
        self.gifImageView.hidden = NO;
    } else {
        self.gifImageView.hidden = YES;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.gifImageView.x = self.width - self.gifImageView.width;
    self.gifImageView.y = self.height - self.gifImageView.height;
    
    CGFloat width = PYScreenW;
    CGFloat height =  width * self.image.size.height / self.image.size.width;
    if (self.isBig) { // 预览状态
        if (height > PYScreenH) { // 长图
            UIScrollView *contentScreollView = self.photoCell.contentScrollView;
            contentScreollView.contentSize = CGSizeMake(width, height);
            contentScreollView.frame = [UIScreen mainScreen].bounds;
        } else {
            self.photoCell.contentScrollView.contentSize = self.size;
        }
    }
}

// 监听滚动，判断cell是否在屏幕上，初始化cell
- (void)collectionViewDidScroll:(NSNotification *)noti
{
    // 取出参数
    NSDictionary *info = noti.userInfo;
    UIScrollView *scrollView = info[PYCollectionViewDidScrollNotification];
    
    if (((self.photoCell.x >= scrollView.contentOffset.x + scrollView.width) || (CGRectGetMaxX(self.photoCell.frame) < scrollView.contentOffset.x)) && self.width >= PYScreenW) { // 不在屏幕上
        // 初始化
        self.transform = CGAffineTransformIdentity;
        self.height = PYScreenW * self.height / self.width;
        self.width = PYScreenW;
        self.photoCell.contentScrollView.contentSize = self.size;
        self.photoCell.contentScrollView.size = self.size;
        self.photoCell.contentScrollView.contentOffset = CGPointZero;
        self.photoCell.contentScrollView.contentInset = UIEdgeInsetsZero;
    }
}

#pragma mark - PYAcitonSheetDeleagate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"保存到相册");
        UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(image: didFinishSavingWithError: contextInfo:), nil);
    } else if(buttonIndex == 1) {
        NSLog(@"分享给朋友");
    } else if (buttonIndex == 2) {
        NSLog(@"取消");
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    error ? [MBProgressHUD showError:@"保存失败"] : [MBProgressHUD showSuccess:@"保存成功"];
}
@end
