//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import "PYMoviePlayerController.h"
#import "PYMoviePlayerView.h"
#import "UIView+PYExtension.h"
#import "PYDownloadDataManager.h"
#import "MBProgressHUD.h"
#import "PYConst.h"
#import "PYPhotoView.h"
#import <AVFoundation/AVFoundation.h>
#import "PYMovie.h"
#import "PYPhotosView.h"
#import "PYMoviePlayerController.h"
#import "PYPhotoCell.h"


@interface PYMoviePlayerController ()<PYMoviePlayerViewDelegate>

/** playerItem */
@property (nonatomic, strong) AVPlayerItem *playerItem;

/** 缓存路径 */
@property (nonatomic, copy) NSString *movieCachePath;

/** 缓存临时路径 */
@property (nonatomic, copy) NSString *movieTempPath;

/** 播放图层 */
@property (nonatomic, weak) AVPlayerLayer *layer;

/** 定时器监听者 */
@property (nonatomic, weak) id timeObserver;

/** 正在播放 */
@property (nonatomic, assign) BOOL playing;

@end

@implementation PYMoviePlayerController
/** 初始化 */
- (void)setup
{
    // 播放按钮
    UIImageView *playButtonView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PYPhotosView.bundle/play"]];
    playButtonView.hidden = YES;
    playButtonView.py_size = CGSizeMake(50, 50);
    [self.view addSubview:playButtonView];
    // 自定义播放的view
    PYMoviePlayerView *playView = [PYMoviePlayerView moviePlayerView];
    playView.delegate = self;
    self.shouldAutoplay = NO;
    [self.view addSubview:playView];
    // 播放时间
    UILabel *durationLabel = [[UILabel alloc] init];
    durationLabel.hidden = YES;
    durationLabel.py_size = CGSizeMake(40, 20);
    durationLabel.font = [UIFont systemFontOfSize:12];
    durationLabel.textColor = [UIColor whiteColor];
    durationLabel.textAlignment = NSTextAlignmentCenter;
    durationLabel.backgroundColor = [UIColor colorWithRed:233 green:233 blue:233 alpha:0.3];
    durationLabel.layer.cornerRadius = 2;
    durationLabel.layer.borderWidth = 1;
    durationLabel.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview:durationLabel];
    
    self.durationLabel = durationLabel;
    self.playView = playView;
    self.playButtonView = playButtonView;
    self.first = YES;
    self.view.backgroundColor = [UIColor blackColor];
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_playerItem removeObserver:self forKeyPath:AVPlayerLoadedTimeRangesKeyPath context:AVPlayerContext];
    [_player removeTimeObserver:self.timeObserver];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.layer.frame = self.view.bounds;
}

#pragma mark - getter
- (AVPlayerItem *)playerItem
{
    if (!_playerItem) {
        // 设置视频链接
        _playerItem = [AVPlayerItem playerItemWithURL:self.URL];
        // 监听加载状态变化
        // 监听加载缓存
        [_playerItem addObserver:self forKeyPath:AVPlayerLoadedTimeRangesKeyPath options:NSKeyValueObservingOptionNew context:nil];
        // 视频播放结束通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return _playerItem;
}

- (AVPlayer *)player
{
    if (!_player) {
        _player = [AVPlayer playerWithPlayerItem:self.playerItem];
        __block  typeof(self) weakSelf = self;
        self.timeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            if (weakSelf.playView.sliding) return ; // 正在滑动 直接返回
            if (weakSelf.player.rate && !weakSelf.playing) { // 播放器正在播放, 但是UI显示暂停
                [weakSelf.playView play];
                weakSelf.playing = YES;
            } else if (!weakSelf.player.rate && weakSelf.playing) { // 播放器暂停但是UI显示播放
                [weakSelf.playView pause];
                weakSelf.playing = NO;
            }
        }];
    }
    return _player;
}

- (NSTimeInterval)currentPlaybackTime
{
    // 获取当前播放时间
    CMTime currentTime = self.player.currentItem.currentTime;
    return currentTime.value ? currentTime.value / currentTime.timescale : 0;
}

// 获取总时长
- (NSTimeInterval)duration
{
    // 获取视频总时间
    CMTime duration = self.player.currentItem.duration;
    return  (double)duration.value / duration.timescale;
}

#pragma mark - setter

- (void)setFullScreen:(BOOL)fullScreen
{
    _fullScreen = fullScreen;
    if (fullScreen) { // 全屏(横屏)、
        self.photoView.photoCell.frame = CGRectMake(0, 0, PYScreenH, PYScreenW);
        self.photoView.frame = self.photoView.photoCell.bounds;
        self.photoView.playerController.playView.frame = self.photoView.photoCell.bounds;
        self.photoView.playerController.view.frame = self.photoView.frame;
        self.photoView.photoCell.contentScrollView.contentSize = self.photoView.photoCell.py_size;
    } else {
        self.layer.bounds = CGRectMake(0, 0, PYScreenW, PYScreenW * self.photoView.photosView.py_width / self.photoView.photosView.photoHeight);
    }
}

- (void)setCurrentPlaybackTime:(NSTimeInterval)time
{
    CMTime currentTime = [self.player currentTime];
    currentTime.value = currentTime.timescale * time;
    [self.player seekToTime:currentTime];
}

- (void)setCurrentPlaybackTime:(NSTimeInterval)time completionHandler:(void (^)(BOOL finished))completionHandler
{
    CMTime currentTime = [self.player currentTime];
    currentTime.value = currentTime.timescale * time;
    [self.player seekToTime:currentTime completionHandler:completionHandler];
}

- (void)setMovie:(PYMovie *)movie
{
    _movie = movie;
    
    // 设置链接
    [self setMovieURL:movie.url];
    // 刷新界面
    [self.playView updateProgress];
}

- (void)setURL:(NSURL *)URL
{
    _URL = URL;
    if (!_player) {
        // 创建播放图层
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        // 插入图层到播放器的view图层中
        [self.view.layer insertSublayer:layer atIndex:0];
        self.layer = layer;
        // 添加通知
        [self.playView addNotification];
    }
}

- (void)setSkip:(BOOL)skip
{
    _skip = skip;
    if (!self.movie.skip) {
        self.movie.skip = skip;
    }
    if (skip && [self shouldAutoplay]) { // shouAutoplay表示大屏
        // 保存时间
        self.movie.lastTime = [self currentPlaybackTime];
        __block typeof(self) weakSelf = self;
        // 快进以后就设置真实网络地址
        if (![self.URL.absoluteString isEqualToString:self.movie.url.absoluteString]) {
            [self setMovieURL:self.movie.url];
            [self setCurrentPlaybackTime:self.movie.lastTime completionHandler:^(BOOL finished) {
                // 更新界面
                [weakSelf.playView updateProgress];
                [weakSelf.player play];
            }];
            
            [_downloadManger cancel];
            _downloadManger = nil;
        }
    }
}

- (void)setNoVideo:(BOOL)noVideo
{
    _noVideo = noVideo;
    
    if (noVideo) { // 不是视频
        // 删除缓存
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        [fileMgr removeItemAtPath:self.movieCachePath error:nil];
        [fileMgr removeItemAtPath:self.movieTempPath error:nil];
        // 取消下载
        [_downloadManger cancel];
        _downloadManger = nil;
        [self.view removeFromSuperview];
    }
}

- (void)setMovieURL:(NSURL *)contentURL
{
    // 网络临时缓存
    NSString *webPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/PYPhotosView/Temp"];
    // 离线缓存
    NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/PYPhotosView/Cache"];
    // 视频地址
    NSString *urlPath = contentURL.lastPathComponent;
    self.movieCachePath = [cachePath stringByAppendingPathComponent:urlPath];
    self.movieTempPath = [webPath stringByAppendingPathComponent:urlPath];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:cachePath])
    {
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if ([fileManager fileExistsAtPath:self.movieCachePath]) { // 已缓存
        // 本地已经有缓存直接播放
        contentURL = [NSURL fileURLWithPath:self.movieCachePath];
        _downloadManger = nil;
    } else if (!self.movie.skip){ // 未缓存
        if (_downloadManger) return; // 已经开始下载
        // 开始加载
        [MBProgressHUD py_showLoading:nil toView:self.view];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:contentURL];
        PYDownloadDataManager *downloadManager = [[PYDownloadDataManager alloc] init];
        _downloadManger = [downloadManager downloadFileWithRequest:request tempFilePatch:self.movieTempPath CacheFilePath:self.movieCachePath bytesReceivedBlock:^(unsigned long long totalBytesDownloaded, unsigned long long totalBytesExpectedToDownload) {
            // 播放
            if (!_isPlay && totalBytesDownloaded > 1 * 1024 * 1024) { // 下载了1MB
                _isPlay = !_isPlay;
                // 播放(通过向本地服务器请求)
                [self setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://127.0.0.1:12345/%@", urlPath]]];
                // 播放
                if (![self shouldAutoplay]) { // 不需要播放
                    [_downloadManger cancel];
                    _downloadManger = nil;                    return ;
                } else {
                    [self.player play];
                }
            }
        }];
    }
    
    [self setURL:contentURL];
}


#pragma mark - PYMoviePlayerViewDelegate
- (void)movicePlayerView:(PYMoviePlayerView *)playerView didPlaybackStateChanged:(PYMoviePlaybackState)state
{
    switch (state) {
        case PYMoviePlaybackStatePlaying:
            [self.player play];
            break;
        case PYMoviePlaybackStatePaused:
            [self.player pause];
            break;
        default:
            break;
    }
}

- (void)closeMoviePlayerView:(PYMoviePlayerView *)playerView
{
    // 关闭播放
    [self movieFinished];
}

- (void)movieDurationAvailable:(PYMoviePlayerView *)playerView
{
    if (![self shouldAutoplay]) { // 还没点击播放
        double totalMinute = floor([self duration] / 60);
        double totalSecond = floor(fmod([self duration], 60));
        self.durationLabel.text = [NSString stringWithFormat:@"%02.0f:%02.0f",totalMinute, totalSecond];
        self.durationLabel.hidden = NO;
        // 时间获取完毕, 取消下载
        [self movieFinished];
    } else {
        self.durationLabel.hidden = YES;
    }
}


#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:AVPlayerLoadedTimeRangesKeyPath]){
        CMTimeRange timeRange = [[self.player.currentItem.loadedTimeRanges firstObject] CMTimeRangeValue];
        self.playableDuration = timeRange.start.value / timeRange.start.timescale + timeRange.duration.value / timeRange.duration.timescale;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

// 视频播放结束
- (void)movieFinished
{
    if (_downloadManger) {
        [_downloadManger cancel];
        _downloadManger = nil;
    }
    self.currentPlaybackTime = 0;
    
}
@end
