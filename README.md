# PYPhotoView
- Framework with a simple method of rendering images.
- 用法简单的呈现一组图片的框架。

## Contents
* Getting Started
  * [Renderings【效果图】](#效果图)
  * [Status 【支持哪些状态】](#支持哪些状态)
  * [Layouts【支持哪些布局】](#支持哪些布局)
  * [Gestures【支持哪些手势】](#支持哪些手势)
  * [What place will use this framework【什么地方用到这个框架】](#什么地方用到这个框架啊啊)
  * [Dependency 【依赖哪些第三方框架】](#依赖哪些第三方框架)
  * [Classes【PYPhotosView框架的主要类】](#PYPhotosView框架的主要类)
  
* 框架使用
  * [How to use【如何使用PYPhotosView】](#如何使用PYPhotosView)
  * [Details 【具体使用(详情见示例程序PYPhotosViewExample)】](#具体使用（详情见示例程序PYPhotosViewExample）)
  * [Custom【自定义photosView】](#自定义photosView)
  
* [期待](#期待什么)

## <a id="效果图"></a>效果图
- **图片已发布（网络图片浏览、流水布局)**

  ![(img)](https://github.com/iphone5solo/learngit/raw/master/imagesForPhotosView/images/PYPhotosView.gif)

- **图片未发布（本地图片上传\发布\预览）**

  ![(img)](https://github.com/iphone5solo/learngit/raw/master/imagesForPhotosView/images/PYPhotosViewWillcompose.gif)

## <a id="支持哪些状态"></a>支持哪些状态
- **已发布（网络图片浏览）**

![(img)](https://github.com/iphone5solo/learngit/raw/master/imagesForPhotosView/images/imagestatedidcompose.png)


- **未发布（本地图片上传\发布\预览）**

  ![(img)](https://github.com/iphone5solo/learngit/raw/master/imagesForPhotosView/images/imgaestatewillcompose.png)

## <a id="支持哪些布局"></a>支持哪些布局
- `流水布局` 、 `线性布局`

## <a id="支持哪些手势"></a>支持哪些手势
- `单击` 、`双击` 、`捏合` 、`旋转`、`拖拽`、`侧滑`

## <a id="什么地方用到这个框架啊啊"></a>什么地方用到这个框架

- 主要用于社交app,用于呈现一组图片
- 以下是各个流行社交app的部分截图

![(img1)](https://github.com/iphone5solo/learngit/raw/master/imagesForPhotosView/images/IMG_0225.PNG)
![(img1)](https://github.com/iphone5solo/learngit/raw/master/imagesForPhotosView/images/IMG_0226.PNG)
![(img1)](https://github.com/iphone5solo/learngit/raw/master/imagesForPhotosView/images/IMG_0227.PNG)
![(img1)](https://github.com/iphone5solo/learngit/raw/master/imagesForPhotosView/images/IMG_0228.PNG)
![(img1)](https://github.com/iphone5solo/learngit/raw/master/imagesForPhotosView/images/IMG_0229.PNG)
![(img1)](https://github.com/iphone5solo/learngit/raw/master/imagesForPhotosView/images/IMG_0230.PNG)

## <a id="依赖哪些第三方框架"></a>依赖哪些第三方框架
* 图片浏览依赖框架
	- `MBProgressHUD`
	- `SDWebImage`
	

## <a id="PYPhotosView框架的主要类"></a>PYPhotosView框架的主要类


### PYPhotosView
```objc


@interface PYPhotosView : UIScrollView

/** 代理 */
@property (nonatomic, weak) id<PYPhotosViewDelegate> delegate;

/** 网络图片模型数组 */
@property (nonatomic, copy) NSArray *photos;
/** 网络图片地址数组（缩略图） */
@property (nonatomic, copy) NSArray *thumbnailUrls;
/** 网络图片地址数组（原图） */
@property (nonatomic, copy) NSArray *originalUrls;
/** 本地相册图片数组(默认最多为九张,当传入图片数组长度超过九张时，取前九张) */
@property (nonatomic, strong) NSMutableArray *images;

/** 所有图片的状态（默认为已发布状态） */
@property (nonatomic, assign) PYPhotosViewState photosState;
/** 图片布局（默认为流水布局） */
@property (nonatomic, assign) PYPhotosViewLayoutType layoutType;
/** 图片分页指示类型(默认为pageControll。当图片超过九张，改为label显示) */
@property (nonatomic, assign) PYPhotosViewPageType pageType;

/** 图片间距（默认为5） */
@property (nonatomic, assign) CGFloat photoMargin;
/** 图片的宽 (默认为70) */
@property (nonatomic, assign) CGFloat photoWidth;
/** 图片的高 (默认为70) */
@property (nonatomic, assign) CGFloat photoHeight;

/** 每行最多个数（默认为3）, 当图片布局为线性布局时，此设置失效 */
@property (nonatomic, assign) NSInteger photosMaxCol;
/** 当图片上传前，最多上传的张数，默认为9 */
@property (nonatomic, assign) NSInteger imagesMaxCountWhenWillCompose;

/** 快速创建photosView对象 */
+ (instancetype)photosView;
/** photos : 保存图片链接的数组 */
+ (instancetype)photosViewWithThumbnailUrls:(NSArray *)thumbnailUrls originalUrls:(NSArray *)originalUrls;
/** images : 存储本地图片的数组 */
+ (instancetype)photosViewWithImages:(NSMutableArray *)images;

/**
 * thumbnailUrls : 保存图片(缩略图)链接的数组
 * originalUrls : 保存图片(原图)链接的数组
 * type : 布局类型（默认为流水布局）
 */
+ (instancetype)photosViewWithThumbnailUrls:(NSArray *)thumbnailUrls originalUrls:(NSArray *)originalUrls layoutType:(PYPhotosViewLayoutType)type;

/** 
 * thumbnailUrls : 保存图片(缩略图)链接的数组
 * originalUrls : 保存图片(原图)链接的数组
 * maxCol : 每行最多显示图片的个数
 */
+ (instancetype)photosViewWithThumbnailUrls:(NSArray *)thumbnailUrls originalUrls:(NSArray *)originalUrls photosMaxCol:(NSInteger)maxCol;

/** 根据图片个数和图片状态自动计算出PYPhontosView的size */
- (CGSize)sizeWithPhotoCount:(NSInteger)count photosState:(NSInteger)state;

/**
 * 刷新图片(未发布)
 * images : 新的图片数组
 */
- (void)reloadDataWithImages:(NSMutableArray *)images;

@end


```

## <a id="如何使用PYPhotosView"></a>如何使用PYPhotosView
* 使用Cocoapods:
  - `pod "PYPhotosView"`
  - 导入主头文件`#import <PYPhotosView.h>`
* 手动导入：
  - 将`PYPhotosView`文件夹中的所有文件拽入项目中
  - 导入主头文件`#import "PYPhotosView.h"`
  - `使用注意:`如果项目本来就有依赖的第三方框架：`MBProgressHUD、SDWebImage`就不必重复导入, 如果没有，选择`Dependency`文件夹中，项目不存在的框架拽入项目。
  
  
### <a id="具体使用（详情见示例程序PYPhotosViewExample）"></a>具体使用（详情见示例程序PYPhotosViewExample）

- **已发布（网络图片浏览）**

    示例代码：

```objc

    // 1. 创建缩略图图片链接数组
    NSMutableArray *thumbnailImageUrls = [NSMutableArray array];
    // 添加图片(缩略图)链接
    [thumbnailImageUrls addObject:@"http://ww3.sinaimg.cn/thumbnail/006ka0Iygw1f6bqm7zukpj30g60kzdi2.jpg"];
    [thumbnailImageUrls addObject:@"http://ww1.sinaimg.cn/thumbnail/61b69811gw1f6bqb1bfd2j20b4095dfy.jpg"];
    [thumbnailImageUrls addObject:@"http://ww1.sinaimg.cn/thumbnail/54477ddfgw1f6bqkbanqoj20ku0rsn4d.jpg"];
    [thumbnailImageUrls addObject:@"http://ww4.sinaimg.cn/thumbnail/006ka0Iygw1f6b8gpwr2tj30bc0bqmyz.jpg"];
    [thumbnailImageUrls addObject:@"http://ww2.sinaimg.cn/thumbnail/9c2b5f31jw1f6bqtinmpyj20dw0ae76e.jpg"];
    [thumbnailImageUrls addObject:@"http://ww1.sinaimg.cn/thumbnail/536e7093jw1f6bqdj3lpjj20va134ana.jpg"];
    [thumbnailImageUrls addObject:@"http://ww1.sinaimg.cn/thumbnail/75b1a75fjw1f6bqn35ij6j20ck0g8jtf.jpg"];
    [thumbnailImageUrls addObject:@"http://ww2.sinaimg.cn/thumbnail/005NFHyQgw1f6bn8bha0eg308w0gib2d.gif"];
    [thumbnailImageUrls addObject:@"http://ww1.sinaimg.cn/thumbnail/86afb21egw1f6bq3lq0itj20gg0c2myt.jpg"];
    
    // 1.2 创建原图图片链接数组
    NSMutableArray *originalImageUrls = [NSMutableArray array];
    // 添加图片(原图)链接
    [originalImageUrls addObject:@"http://ww3.sinaimg.cn/large/006ka0Iygw1f6bqm7zukpj30g60kzdi2.jpg"];
    [originalImageUrls addObject:@"http://ww1.sinaimg.cn/large/61b69811gw1f6bqb1bfd2j20b4095dfy.jpg"];
    [originalImageUrls addObject:@"http://ww1.sinaimg.cn/large/54477ddfgw1f6bqkbanqoj20ku0rsn4d.jpg"];
    [originalImageUrls addObject:@"http://ww4.sinaimg.cn/large/006ka0Iygw1f6b8gpwr2tj30bc0bqmyz.jpg"];
    [originalImageUrls addObject:@"http://ww2.sinaimg.cn/large/9c2b5f31jw1f6bqtinmpyj20dw0ae76e.jpg"];
    [originalImageUrls addObject:@"http://ww1.sinaimg.cn/large/536e7093jw1f6bqdj3lpjj20va134ana.jpg"];
    [originalImageUrls addObject:@"http://ww1.sinaimg.cn/large/75b1a75fjw1f6bqn35ij6j20ck0g8jtf.jpg"];
    [originalImageUrls addObject:@"http://ww2.sinaimg.cn/large/005NFHyQgw1f6bn8bha0eg308w0gib2d.gif"];
    [originalImageUrls addObject:@"http://ww1.sinaimg.cn/large/86afb21egw1f6bq3lq0itj20gg0c2myt.jpg"];
  
  // 2. 创建一个photosView
  PYPhotosView *photosView = [PYPhotosView photosViewWithThumbnailUrls:thumbnailImageUrls originalUrls:originalImageUrls];
  
  // 3. 添加photosView
  [self.view addSubview:photosView];
  
```
  
- **未发布（本地图片上传\发布\预览）**

   示例代码：

```objc
    
    // 1. 创建本地图片数组
    NSMutableArray *imagesM = [NSMutableArray array];
    for (int i = 0; i < arc4random_uniform(4) + 1; i++) {
        [imagesM addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%02d", i + 1]]];
    }
    
    // 2.1 设置本地图片
  	PYPhotosView *photosView = [PYPhotosView photosViewWithImages:imagesM];
    
    // 3. 设置代理
    photosView.delegate = self;
    
    // 4. 添加photosView
    [self.view addSubview:photosView];

```
 
## <a id="自定义photosView"></a>自定义photosView

### 通过设置photosView的对象属性值即可修改

* 设置布局类型（默认为流水布局）
```objc
// 设置布局为线性布局
photosView.layoutType = PYPhotosViewLayoutTypeLine;

```

* 设置分页指示类型（默认为pageControll指示器）
```objc
// 设置指示类型为文本指示
photosView.pageType = PYPhotosViewPageTypeLabel;
```

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
* 设置图片上传前，最多上传的张数（默认为9）

```objc
// 设置图片最多上传的张数
photosView.imagesMaxCountWhenWillCompose = 15;
```

## <a id="期待什么"></a>期待

- 如果您在使用过程中有任何问题，欢迎直接加我QQ:499491531联系，很乐意为您解答任何相关问题
- 与其给我点star，不如向我狠狠地抛来一个BUG！
- 如果感兴趣的小伙伴想要参与这个项目的维护，可以及时联系我。
- 最后，不要再调侃`PY`了，我们都纯洁一点好不好！！！
