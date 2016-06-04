#import <UIKit/UIKit.h>
#import "UIView+PYExtension.h"
#import "UIImage+PYTool.h"
#import "UIImageView+PYExtension.h"
#import "MBProgressHUD+MJ.h"

#define PYMargin 10

// 颜色
#define PYColor(r,g,b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]
#define PYRandomColor  PYColor(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))

// 屏幕宽高
#define PYScreenW [UIScreen mainScreen].bounds.size.width
#define PYScreenH [UIScreen mainScreen].bounds.size.height

// 占位图
#define PYPlaceholderImage [UIImage imageNamed:@"py_placeholderimage"] ? [UIImage imageNamed:@"py_placeholderimage"] : [UIImage imageNamed:@"PYPhotosView.bundle/placeholderimage"]

// 获取当前控制器
#define PYCurrentController [[UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers lastObject]

// 判断当前系统版本
#define PYIOS8 [[UIDevice currentDevice].systemVersion floatValue] >= 8.0 && [[UIDevice currentDevice].systemVersion floatValue] < 9.0
#define PYIOS9 [[UIDevice currentDevice].systemVersion floatValue] >= 9.0 && [[UIDevice currentDevice].systemVersion floatValue] < 10.0

UIKIT_EXTERN NSString *const PYBigImageDidClikedNotification;   // 大图被点击（缩小）
UIKIT_EXTERN NSString *const PYSmallgImageDidClikedNotification;    // 小图被点击（放大）
UIKIT_EXTERN NSString *const PYImagePageDidChangedNotification;     // 浏览过程中的图片被点击（放回原位）
UIKIT_EXTERN NSString *const PYPreviewImagesDidChangedNotification; // 预览图片被点击
UIKIT_EXTERN NSString *const PYChangeNavgationBarStateNotification;
UIKIT_EXTERN NSString *const PYAddImageDidClickedNotification;
UIKIT_EXTERN NSString *const PYCollectionViewDidScrollNotification; // 滚动通知


