# PYPhotoView
- Framework with a simple method of rendering images
- 用法简单的呈现一组图片的框架

## Contents
* Getting Started
  * [Gestures【支持哪些手势】](#支持哪些手势)
  * [What place will use this framework【什么地方用到这个框架】](#什么地方用到这个框架啊啊)
  * [Classes【PYPhotosView框架的主要类】](#PYPhotosView框架的主要类)
  
* 框架使用
  * [How to use【如何使用PYPhotosView】](#如何使用PYPhotosView)
  * [Details 【具体使用(详情见示例程序中的PYExampleViewController)】](#具体使用（详情见示例程序中的PYExampleViewController）)
  * [Custom【自定义photosView】](#自定义photosView)
  
* [期待](#期待什么)

## <a id="支持哪些手势"></a>支持哪些手势
- `单击` 、`双击` 、`捏合` 、`旋转`

## <a id="什么地方用到这个框架啊啊"></a>什么地方用到这个框架

- 主要用于社交app,用于呈现一组图片
- 以下是各个流行社交app的部分截图

![(img1)](https://github.com/iphone5solo/learngit/raw/master/imagesForPhotosView/images/IMG_0225.PNG)
![(img1)](https://github.com/iphone5solo/learngit/raw/master/imagesForPhotosView/images/IMG_0226.PNG)
![(img1)](https://github.com/iphone5solo/learngit/raw/master/imagesForPhotosView/images/IMG_0227.PNG)
![(img1)](https://github.com/iphone5solo/learngit/raw/master/imagesForPhotosView/images/IMG_0228.PNG)
![(img1)](https://github.com/iphone5solo/learngit/raw/master/imagesForPhotosView/images/IMG_0229.PNG)
![(img1)](https://github.com/iphone5solo/learngit/raw/master/imagesForPhotosView/images/IMG_0230.PNG)

## <a id="PYPhotosView框架的主要类"></a>PYPhotosView框架的主要类


### PYPhotosView
```objc

@interface PYPhotosView : UIScrollView

/** 网络图片相册 */
@property (nonatomic, strong) NSArray *photos;
/** 本地相册图片数组 */
@property (nonatomic, strong) NSMutableArray *images;
/** 所有图片的状态 */
@property (nonatomic, assign) NSInteger photosState;

/** 图片间距（默认为5） */
@property (nonatomic, assign) CGFloat photoMargin;
/** 图片的宽高（正方形）默认为70 */
@property (nonatomic, assign) CGFloat photoWH;
/** 每行最多个数（默认为3） */
@property (nonatomic, assign) NSInteger photosMaxCol;

/** 快速创建photosView对象 */
+ (instancetype)photosView;
/** photos: 保存图片链接的数组 */
+ (instancetype)photosView:(NSArray *)photos;

/** 根据图片个数和图片状态自动计算出PYPhontosView的size */
- (CGSize)sizeWithPhotoCount:(NSInteger)count photosState:(NSInteger)state;

@end

```

## <a id="如何使用PYPhotosView"></a>如何使用PYPhotosView

* 手动导入：
  - 将`PYPhotosView`文件夹中的所有文件拽入项目中
  - 导入主头文件`#import "PYPhotosView.h"`
  
### <a id="具体使用（详情见示例程序中的PYExampleViewController）"></a>具体使用（详情见示例程序中的PYExampleViewController）

1. 创建图片链接数组
2. 创建photosView对象
3. 添加对象


示例代码：

```objc

// 1.1 创建图片链接数组
NSMutableArray *imageUrls = [NSMutableArray array];
   
  for (int i = 0; i < 6; i++) {
      // 1.2 图片链接
      NSString *imageUrl = [NSString stringWithFormat:@"https://github.com/iphone5solo/PYPhotosView/raw/master/images/IMG_02%02d.PNG", 25+i];
      // 1.3 添加图片链接
      [imageUrls addObject:imageUrl];
  }
  
  // 2. 创建一个photosView
  PYPhotosView *photosView = [PYPhotosView photosView:imageUrls];
  
  // 3. 添加photosView
  [self.view addSubview:photosView];
  
```
  
## <a id="自定义photosView"></a>自定义photosView

### 通过设置photosView的对象属性值即可修改
* 设置图片间距（默认为5）
```objc
 // 设置图片间距为10
 photosView.photoMargin = 10;
```

* 设置图片大小（默认70\*70）

```objc

// 设置图片的宽（width）
photosView.photoWidth = 100;
// 设置图片的高（height）
photosView.photoHeight = 60;

```

* 设置每行图片最多个数（默认为3个）
```objc
// 设置图片最多列数
photosView.photosMaxCol = 6;

```
## <a id="期待什么"></a>期待

- 如果在使用过程中遇到BUG,希望您呢个Issues我，谢谢（或者尝试下载最新的框架代码看看BUG修复没有）
- 如果在使用过程中发现功能不够用，希望你能Issues我，我非常想为这个框架增加更多好用的功能，谢谢
- 如果你想为PYPhotosView输出代码，请拼命Pull Requests我
