//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYMoviePlayerController.h"
@class PYMoviePlayerView;
@protocol PYMoviePlayerViewDelegate <NSObject>

@optional
- (void)movicePlayerView:(PYMoviePlayerView *)playerView didPlaybackStateChanged:(MPMoviePlaybackState)state;

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
// 更新进度
- (void)updateProgress;
@end
