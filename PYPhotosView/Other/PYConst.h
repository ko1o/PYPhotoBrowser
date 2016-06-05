#import <UIKit/UIKit.h>
#import "UIView+PYExtension.h"
#import "MBProgressHUD+MJ.h"



/** --------------可修改的宏定义------------- */
#define PYPhotoMaxScale 3   // 图片最大放大倍数
#define PYPhotoMargin 5     // 图片之间的默认间距
#define PYPhotoWidth 70     // 图片的默认宽度
#define PYPhotoHeight 70    // 图片的默认高度
#define PYPhotosMaxCol 3    // 图片每行默认最多个数
#define PYPreviewPhotoSpacing 30 // 预览图片时，图片的间距

#define PYPlaceholderImage [UIImage imageNamed:@"PYPhotosView.bundle/placeholderimage"] // 占位图


/** ---------------建议不修改的宏定义------------- */
#define PYMargin 10 // 边距
// 颜色
#define PYColor(r,g,b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]
#define PYRandomColor  PYColor(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))

// 屏幕宽高
#define PYScreenW [UIScreen mainScreen].bounds.size.width
#define PYScreenH [UIScreen mainScreen].bounds.size.height

// 获取当前控制器
#define PYCurrentController [[UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers lastObject]

// 判断当前系统版本
#define PYIOS8 [[UIDevice currentDevice].systemVersion floatValue] >= 8.0 && [[UIDevice currentDevice].systemVersion floatValue] < 9.0
#define PYIOS9 [[UIDevice currentDevice].systemVersion floatValue] >= 9.0 && [[UIDevice currentDevice].systemVersion floatValue] < 10.0


/** ---------------自定义通知------------- */
UIKIT_EXTERN NSString *const PYBigImageDidClikedNotification;       // 大图被点击（缩小）
UIKIT_EXTERN NSString *const PYSmallgImageDidClikedNotification;    // 小图被点击（放大）
UIKIT_EXTERN NSString *const PYImagePageDidChangedNotification;     // 浏览过程中的图片被点击（放回原位）
UIKIT_EXTERN NSString *const PYPreviewImagesDidChangedNotification; // 预览图片被点击
UIKIT_EXTERN NSString *const PYChangeNavgationBarStateNotification; // 改变状态栏
UIKIT_EXTERN NSString *const PYAddImageDidClickedNotification;      // 添加图片被点击
UIKIT_EXTERN NSString *const PYCollectionViewDidScrollNotification; // 滚动通知


