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

@interface PYPhotoView ()<UIActionSheetDelegate>

/** gif图片*/
@property (nonatomic, weak) UIImageView *gifImageView;

@end

@implementation PYPhotoView

- (instancetype)init
{
    if (self = [super init]) {
        // 运行与用户交互
        self.userInteractionEnabled = YES;
        // 添加单击手势
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidClicked:)];
        [self addGestureRecognizer:tapRecognizer];
        // 添加双击手势
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidDoubleClicked:)];
        [doubleTap setNumberOfTapsRequired:2];
        [self addGestureRecognizer:doubleTap];
        
        // 添加长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidLongPress:)];
        [self addGestureRecognizer:longPress];
        
        // 添加捏合手势
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidPinch:)];
        [self addGestureRecognizer:pinch];
        
                                                     
    }
    return self;
}

// 捏合手势
- (void)imageDidPinch:(UIPinchGestureRecognizer *)pinch
{
    if (self.isBig) {  // 放大状态
        self.transform = CGAffineTransformScale(self.transform, pinch.scale, pinch.scale);
        // 复位
        pinch.scale = 1;
    };
    
    if (pinch.state == UIGestureRecognizerStateEnded) { // 手势结束
        if (!self.isBig) { // 放大状态
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
            if (self.width > lastWindow.width * 2) { // 最大放大1.5倍
                scale = lastWindow.width * 2 / self.width;
            }
        }
        // 复位
        [UIView animateWithDuration:0.25  delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.transform = CGAffineTransformScale(self.transform,scale,scale);
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
}

// 长按手势
- (void)imageDidLongPress:(UITapGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateEnded) {
        // 判断图片是否是放大状态(如果不是放大状态，手势无效)
        if (!self.isBig) { // 长按转为单击
            [self imageDidClicked:nil];
            return;
        };
    }
    
    if (longPress.state == UIGestureRecognizerStateBegan) {  // 长按结束
        if (self.isBig) { // 大图状态
            // 跳出提示
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到相册", @"发送给朋友", nil];
            sheet.delegate = self;
            
            [sheet showInView:self.window];
        }
    }
}


#pragma mark - PYAcitonSheetDeleagate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"保存到相册");
        UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(image: didFinishSavingWithError: contextInfo:), nil);
        
    }else if(buttonIndex == 1){
        NSLog(@"分享给朋友");
    }else if (buttonIndex == 2){
        NSLog(@"取消");
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [MBProgressHUD showError:@"保存失败"];
    }else{
        [MBProgressHUD showSuccess:@"保存成功"];
    }
}

// 双击手势
- (void)imageDidDoubleClicked:(UITapGestureRecognizer *)sender
{
    // 判断图片是否是放大状态(如果不是放大状态，手势无效)
    if (!self.isBig) return;
    
    NSLog(@"双击手势---");
}
                                        

// 点击
- (void)imageDidClicked:(UITapGestureRecognizer *)sender
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    if (self.photosView.photosState == PYPhotosViewStateDidCompose) { // 已发布
        if (!self.isBig){ // 放大
            // 遍历所有photoFrame记录原始frame
            for (PYPhotoView *photoView in self.photosView.subviews) {
                photoView.orignalFrame = photoView.frame;
            }
            // 发出通知
            userInfo[PYBigImageDidClikedNotification] = self;
            NSNotification *notification = [[NSNotification alloc] initWithName:PYBigImageDidClikedNotification object:sender userInfo:userInfo];
            [center postNotification:notification];
        }else{ // 缩小
            userInfo[PYSmallgImageDidClikedNotification] = self;
            NSNotification *notification = [[NSNotification alloc] initWithName:PYSmallgImageDidClikedNotification object:sender userInfo:userInfo];
            [center postNotification:notification];
        }
    }else if (self.photosView.photosState == PYPhotosViewStateWillCompose){ // 未发布
        if (self.isPreview){ // 正在预览
                NSNotification *notifaction = [[NSNotification alloc] initWithName:PYChangeNavgationBarStateNotification object:sender userInfo:userInfo];
                [center postNotification:notifaction];
            
        }else { // 将要预览
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
        UIImageView *gifView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_image_gif"]];
        _gifImageView = gifView;
        [self addSubview:gifView];
    }
    return _gifImageView;
}

- (void)setPhoto:(NSString *)photo
{
    _photo = photo;
    
    // 设置图片
    NSURL *imgUrl = [NSURL URLWithString:photo];
    
    [self sd_setImageWithURL:imgUrl placeholderImage:PYPlaceholderImage];
    
    
    
    if([photo.lowercaseString hasSuffix:@"gif"]){ // 以gif或者GIF结尾的图片
        self.gifImageView.hidden = NO;
    }else{
        self.gifImageView.hidden = YES;
    }
    
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.gifImageView.x = self.width - self.gifImageView.width;
    self.gifImageView.y = self.height - self.gifImageView.height;
}





@end
