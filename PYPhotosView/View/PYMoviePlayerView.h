//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//  用于视频播放的视图

#import <UIKit/UIKit.h>
#import "PYMoviePlayerController.h"
@class PYMoviePlayerView;
@protocol PYMoviePlayerViewDelegate <NSObject>

@optional
- (void)movicePlayerView:(PYMoviePlayerView *)playerView didPlaybackStateChanged:(PYMoviePlaybackState)state;

- (void)movieDurationAvailable:(PYMoviePlayerView *)playerView;

- (void)closeMoviePlayerView:(PYMoviePlayerView *)playerView;

@end

@interface PYMoviePlayerView : UIView
/** 视频封面 */
@property (nonatomic, strong) UIImage *movieImage;

@property (nonatomic, weak) id<PYMoviePlayerViewDelegate> delegate;

+ (instancetype)moviePlayerView;

/** 是否正在加载 */
@property (nonatomic, assign, getter=isLoading) BOOL loading;
/** 最近一次播放时间 */
@property (nonatomic, assign) NSTimeInterval lastTime;
/** 正在滑动 */
@property (nonatomic, assign) BOOL sliding;
// 添加通知
- (void)addNotification;
// 更新进度
- (void)updateProgress;
- (void)play; // 播放
- (void)pause; // 暂停
@end
