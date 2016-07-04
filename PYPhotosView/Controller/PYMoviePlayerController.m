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
    playButtonView.py_size = CGSizeMake(50, 50);
    [self.view addSubview:playButtonView];
    [self.view addSubview:playView];
    self.playView = playView;
    self.playButtonView = playButtonView;
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


- (void)setContentURL:(NSURL *)contentURL
{
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
    } else { // 未缓存
        // 加载缓存
        self.playView.loading = YES;
        ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:contentURL];
        //下载完存储目录
        [request setDownloadDestinationPath:[cachePath stringByAppendingPathComponent:contentURL.lastPathComponent]];
        //临时存储目录
        [request setTemporaryFileDownloadPath:[webPath stringByAppendingPathComponent:contentURL.lastPathComponent]];
        [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
            // 暂停
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setDouble:total forKey:@"file_length"];
            Recordull += size;//Recordull全局变量，记录已下载的文件的大小
            if (!isPlay && Recordull > 400000) {
                NSLog(@"发请求给本地服务器");
                // 停止加载菊花
                self.playView.loading = NO;
                isPlay = !isPlay;
                // 播放(通过向本地服务器请求)
                NSString *head = PYIOS8 ? @"http" : @"https";
                [super setContentURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@://127.0.0.1:12345/%@",head, contentURL.lastPathComponent]]];
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
