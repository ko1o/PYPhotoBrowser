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

@interface PYMoviePlayerController ()<PYMoviePlayerViewDelegate>

/** 视频大小 */
@property (nonatomic, assign) unsigned long long movieTotalSize;

/** 视频缓存路径 */
@property (nonatomic, copy) NSString *cachePath;

@end

@implementation PYMoviePlayerController

/** 初始化 */
- (void)setup
{
    [self.playView removeFromSuperview];
    [self.playButtonView removeFromSuperview];
    PYMoviePlayerView *playView = [PYMoviePlayerView moviePlayerView];
    playView.delegate = self;
    self.shouldAutoplay = NO;
    UIImageView *playButtonView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play"]];
    playButtonView.hidden = YES;
    playButtonView.py_size = CGSizeMake(50, 50);
    [self.view addSubview:playButtonView];
    [self.view addSubview:playView];
    self.playView = playView;
    self.playButtonView = playButtonView;
    self.scalingMode = MPMovieScalingModeAspectFit;
    //视频播放结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

- (instancetype)init
{
    if ([super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithContentURL:(NSURL *)url
{
    if (self = [super initWithContentURL:url]) {
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
    
    if (skip && self.cachePath) {
        // 保存时间
        double currentTime = self.currentPlaybackTime;
        // 快进以后就设置真实网络地址
        self.contentURL = [NSURL URLWithString:self.movieNetworkUrl];
        // 恢复时间
        self.currentPlaybackTime = currentTime;
        self.initialPlaybackTime = self.currentPlaybackTime;
        // 更新界面
        [self.playView updateProgress];
        // 播放
        [self play];
        self.cachePath = nil;
        [videoRequest clearDelegatesAndCancel];
        videoRequest = nil;
    }
}

- (void)setContentURL:(NSURL *)contentURL
{
    // 链接为空
    if (!contentURL.absoluteString) return;
    
    // 网络临时缓存
    NSString *webPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];
    // 离线缓存
    NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Cache"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:cachePath])
    {
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if ([fileManager fileExistsAtPath:[cachePath stringByAppendingPathComponent:contentURL.lastPathComponent]]) { // 已缓存
        // 本地已经有缓存直接播放
        contentURL = [NSURL fileURLWithPath:[cachePath stringByAppendingPathComponent:contentURL.lastPathComponent]];
        videoRequest = nil;
    } else if (!self.skip){ // 未缓存
        // 开始加载
        [MBProgressHUD py_showLoading:nil toView:self.view];
        ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:contentURL];
        //下载完存储目录
        [request setDownloadDestinationPath:[cachePath stringByAppendingPathComponent:contentURL.lastPathComponent]];
        self.cachePath = [cachePath stringByAppendingString:contentURL.lastPathComponent];
        //临时存储目录
        [request setTemporaryFileDownloadPath:[webPath stringByAppendingPathComponent:contentURL.lastPathComponent]];
        [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
            
            self.movieTotalSize = total;
            // 暂停
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setDouble:total forKey:@"file_length"];
            Recordull += size;//Recordull全局变量，记录已下载的文件的大小
            if (!isPlay && Recordull > 400000) {
                // 隐藏加载
                [MBProgressHUD hideHUDForView:self.view animated:NO];
                
                isPlay = !isPlay;
                
                NSLog(@"请求本地地址");
                
                // 播放(通过向本地服务器请求)
                [super setContentURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://127.0.0.1:12345/%@",contentURL.lastPathComponent]]];
                
                // 播放
                if (![self shouldAutoplay]) return ;
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
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if ([fileMgr fileExistsAtPath:self.cachePath]) { // 存在文件
        if([[fileMgr attributesOfItemAtPath:self.cachePath error:nil] fileSize] != self.movieTotalSize) { // 缓存视频和实际视频大小不一样，删除
            [fileMgr removeItemAtPath:self.cachePath error:nil];
            NSLog(@"删除文件");
        } else {
            NSLog(@"缓存视频");
        }
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

@end
