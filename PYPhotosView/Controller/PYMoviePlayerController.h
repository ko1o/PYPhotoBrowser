//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//


#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
@class PYMoviePlayerView, PYMovie, PYPhotoView, PYDownloadDataManager;

#define AVPlayerStatusKeyPath @"status"
#define AVPlayerLoadedTimeRangesKeyPath @"loadedTimeRanges"

@interface PYMoviePlayerController : UIViewController
{
    PYDownloadDataManager *_downloadManger;
    unsigned long long _recordull;
    BOOL _isPlay;
}

typedef NS_ENUM(NSInteger,  PYMoviePlayerStatus) {
    PYMoviePlayerStatusUnknown,
    PYMoviePlayerStatusReadyToPlay,
    PYMoviePlayerStatusStop
};

typedef NS_ENUM(NSInteger,  PYMoviePlaybackState) {
    PYMoviePlaybackStateStopped,
    PYMoviePlaybackStatePlaying,
    PYMoviePlaybackStatePaused,
};

/** 自定义控制view */
@property (nonatomic, weak) PYMoviePlayerView *playView;
/** 播放按钮图片 */
@property (nonatomic, weak) UIImageView *playButtonView;
/** 播放时间 */
@property (nonatomic, weak) UILabel *durationLabel;
/** 视频模型 */
@property (nonatomic, strong) PYMovie *movie;
/** 快进了 */
@property (nonatomic, assign) BOOL skip; // 是否快进了（想要观看的时间超过了已缓存）
/** 不是视频 */
@property (nonatomic, assign) BOOL noVideo;
/** 是否是刚进入 */
@property (nonatomic, assign) BOOL first;
/** 是否自动播放（也作为是否是大屏播放的标记） */
@property (nonatomic, assign) BOOL shouldAutoplay;
/** 是否全屏 */
@property (nonatomic, assign) BOOL fullScreen;
/** 可播放的时间（以下载） */
@property (nonatomic, assign) NSTimeInterval playableDuration;
/** 播放器对象 */
@property (nonatomic, strong) AVPlayer *player;
/** 当前播放视频的URL */
@property (nonatomic, strong) NSURL *URL;
/** 总时长 */
@property (nonatomic, assign, readonly) NSTimeInterval duration;
/** 播放状态 */
@property (nonatomic, assign, readonly) PYMoviePlayerStatus playbackState;
/** 播放器所在的photoView */
@property (nonatomic, weak) PYPhotoView *photoView;

/** 设置当前时间 */
- (void)setCurrentPlaybackTime:(NSTimeInterval)time;
- (void)setCurrentPlaybackTime:(NSTimeInterval)time completionHandler:(void (^)(BOOL finished))completionHandler;
/** 获取当前时间 */
- (NSTimeInterval)currentPlaybackTime;

@end
