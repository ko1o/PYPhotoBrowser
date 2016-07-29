# PYPhotoView
- Framework with a simple method of rendering images and play video
- 用法简单的呈现一组图片和视频播放的框架

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
  
- **视频播放**

  ![(img)](https://github.com/iphone5solo/learngit/raw/master/imagesForPhotosView/images/PYMoviePlay.gif)

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
* 视频播放依赖框架
	- `HttpServer`
	

## <a id="PYPhotosView框架的主要类"></a>PYPhotosView框架的主要类


### PYPhotosView
```objc

@interface PYPhotosView : UIScrollView

/** 代理 */
@property (nonatomic, weak) id<PYPhotosViewDelegate> delegate;

/** 网络图片相册 */
@property (nonatomic, strong) NSArray *photos;
/** 本地相册图片数组(默认最多为九张,当传入图片数组长度超过九张时，取前九张) */
@property (nonatomic, strong) NSMutableArray *images;
/** 视频链接(视频来自网络) **/
@property (nonatomic, copy) NSString *movieNetworkUrl;
/** 本地视频地址(带有文件类型后缀) */
@property (nonatomic, copy) NSString *movieLocalUrl;

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
+ (instancetype)photosViewWithPhotos:(NSArray *)photos;
/** images : 存储本地图片的数组 */
+ (instancetype)photosViewWithImages:(NSMutableArray *)images;

/**
 * photos : 保存图片链接的数组
 * type : 布局类型（默认为流水布局）
 */
+ (instancetype)photosView:(NSArray *)photos layoutType:(PYPhotosViewLayoutType)type;

/** 
 * photos : 保存图片链接的数组
 * maxCol : 每行最多显示图片的个数
 */
+ (instancetype)photosView:(NSArray *)photos photosMaxCol:(NSInteger)maxCol;

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
  - `使用注意:`如果项目本来就有依赖的第三方框架：`MBProgressHUD（用于图片浏览、发布）、SDWebImage（用于图片浏览、发布）、HttpServer（用于视频播放、缓存）`，就不必重复导入, 如果没有，选择`Dependency`文件夹中，项目不存在的框架拽入项目。
  
 **视频播放使用注意：**
 
 需要在`AppDelegate.m`导入 `HTTPServer.h`、`DDLog.h`、`DDTTYLogger.h`头文件并实现以下这些方法（具体参考PYPhotosViewExample中的`AppDelegate.m`）文件
 
 ```
 
 - (void)startServer
{
    // Start the server (and check for problems)
    NSError *error;
    if([httpServer start:&error])
    {
        NSLog(@"Started HTTP Server on port %hu", [httpServer listeningPort]);
    }
    else
    {
        NSLog(@"Error starting HTTP Server: %@", error);
    }
}

// 程序启动完毕调用
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // 创建本地服务器
    httpServer = [[HTTPServer alloc] init];
    // 设置通讯类型为tcp
    [httpServer setType:@"_http._tcp."];
    // 设置端口
    [httpServer setPort:12345];
    
    // Serve files from our embedded Web folder
    NSString *webPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/PYPhotosView/Temp"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:webPath])
    {
        [fileManager createDirectoryAtPath:webPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [httpServer setDocumentRoot:webPath];
    
    [self startServer];
    
    return YES;
}

// 程序进入后台运行时调用
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [httpServer stop];
}

// 程序回到前台运行时调用
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self startServer];
}
 
 ```
  
  
### <a id="具体使用（详情见示例程序PYPhotosViewExample）"></a>具体使用（详情见示例程序PYPhotosViewExample）

- **已发布（网络图片浏览）**

    示例代码：

```objc

// 1.1 创建图片链接数组
NSMutableArray *imageUrls = [NSMutableArray array];
   
  for (int i = 0; i < 9; i++) {
      // 1.2 图片链接
      NSString *imageUrl = [NSString stringWithFormat:@"https://github.com/iphone5solo/learngit/raw/master/imagesForPhotosView/image%02d.jpg", i + 1];
      // 1.3 添加图片链接
      [imageUrls addObject:imageUrl];
  }
  
  // 2. 创建一个photosView
  PYPhotosView *photosView = [PYPhotosView photosViewWithPhotos:imageUrls];
  
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

- **视频播放**
 
 示例代码
```objc

	// 1. 创建视频播放的photosView
    PYPhotosView *moviePhotosView = [PYPhotosView photosView];
    
    // 2. 设置视频的网络链接
    moviePhotosView.movieNetworkUrl = @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";
    
    // 3. 添加photosView
    [self.view addSubview:moviePhotosView];

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
photosView.imagesMaxCountWhenWillCompose = 15；
```

## <a id="期待什么"></a>期待

- 如果您在使用过程中有任何问题，欢迎直接加我QQ:499491531联系，很乐意为您解答任何相关问题
- 与其给我点star,不如向我狠狠地抛来一个BUG，这样更能证明你下载、运行了代码！
- 如果感兴趣的小伙伴想要参与这个项目的维护，可以及时联系我，本人表示很愿意。
- 还有不要在调侃`PY`了，我们都纯洁一点好不好！！！
