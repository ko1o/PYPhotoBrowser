//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import "PYMoviePlayerController.h"
#import "PYMoviePlayerView.h"
#import "UIView+PYExtension.h"
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "PYConst.h"
#import "PYPhotoView.h"
#import <AVKit/AVKit.h>

@interface PYMoviePlayerController ()<PYMoviePlayerViewDelegate>

/** 缓存路径 */
@property (nonatomic, copy) NSString *movieCachePath;

/** 缓存临时路径 */
@property (nonatomic, copy) NSString *movieTempPath;

@end

@implementation PYMoviePlayerController

/** 初始化 */
- (void)setup
{
    // 自定义播放的view
    PYMoviePlayerView *playView = [PYMoviePlayerView moviePlayerView];
    playView.delegate = self;
    self.shouldAutoplay = NO;
    // 播放按钮
    UIImageView *playButtonView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play"]];
    playButtonView.hidden = YES;
    playButtonView.py_size = CGSizeMake(50, 50);
    [self.view addSubview:playButtonView];
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
    self.scalingMode = MPMovieScalingModeAspectFit;
    // 视频播放结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

- (instancetype)init
{
    if ([super init]) {
        [self setup];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setSkip:(BOOL)skip
{
    _skip = skip;
    
    if (skip) {
        // 保存时间
        self.lastPlaybackTime = self.currentPlaybackTime;
        // 快进以后就设置真实网络地址
        if (![self.contentURL.absoluteString isEqualToString:self.movieNetworkUrl]) {
            self.contentURL = [NSURL URLWithString:self.movieNetworkUrl];
            // 更新界面
            [self.playView updateProgress];
            [self play];
            [videoRequest clearDelegatesAndCancel];
            videoRequest = nil;
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
        [videoRequest clearDelegatesAndCancel];
        videoRequest = nil;
        [self.view removeFromSuperview];
    }
}

- (void)setContentURL:(NSURL *)contentURL
{
    // 网络临时缓存
    NSString *webPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];
    // 离线缓存
    NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Cache"];
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
        videoRequest = nil;
    } else if (!self.skip){ // 未缓存
        if (videoRequest) return; // 已经开始下载
        // 开始加载
        [MBProgressHUD py_showLoading:nil toView:self.view];
        
        ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:contentURL];
        
        //下载完存储目录
        [request setDownloadDestinationPath:self.movieCachePath];
        //临时存储目录
        [request setTemporaryFileDownloadPath:self.movieTempPath];
        
        [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
            Recordull += size;
            // 暂停
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setDouble:total forKey:@"file_length"];
            // 播放
            if (!isPlay && Recordull > 1 * 1024 * 1024) { // 下载了1MB
                isPlay = !isPlay;
                // 播放(通过向本地服务器请求)
                [super setContentURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://127.0.0.1:12345/%@", urlPath]]];
                // 播放
                if (![self shouldAutoplay]) { // 不需要播放
                    [videoRequest clearDelegatesAndCancel];
                    videoRequest = nil;
                    return ;
                }
                [self play];
            }
        }];
        //断点续载
        [request setAllowResumeForFileDownloads:YES];
        [request startAsynchronous];
        videoRequest = request;
    }
    
    [super setContentURL:contentURL];
}

// 视频播放结束
- (void)movieFinished
{
    if (videoRequest) {
        isPlay = !isPlay;
        [videoRequest clearDelegatesAndCancel];
        videoRequest = nil;
    }
}

#pragma mark - PYMoviePlayerViewDelegate
- (void)movicePlayerView:(PYMoviePlayerView *)playerView didPlaybackStateChanged:(MPMoviePlaybackState)state
{
    switch (state) {
        case MPMoviePlaybackStatePlaying:
            [self play];
            break;
        case MPMoviePlaybackStatePaused:
            [self pause];
            break;
        default:
            break;
    }
}

- (void)movieDurationAvailable:(PYMoviePlayerView *)playerView
{
    if (![self shouldAutoplay]) { // 还没点击播放
        double totalMinute = floor(self.duration / 60);
        double totalSecond = floor(fmod(self.duration, 60));
        self.durationLabel.text = [NSString stringWithFormat:@"%02.0f:%02.0f",totalMinute, totalSecond];
        self.durationLabel.hidden = NO;
        // 时间获取完毕, 取消下载
        [self movieFinished];
    } else {
        self.durationLabel.hidden = YES;
    }
}

- (void)closeMoviePlayerView:(PYMoviePlayerView *)playerView
{
    // 关闭播放
    [self movieFinished];
}

@end
