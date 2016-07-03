//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import "PYMoviePlayerController.h"
#import "PYMoviePlayerView.h"
#import "UIView+PYExtension.h"

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

#pragma mark - PYMoviePlayerViewDelegate
- (void)movicePlayerView:(PYMoviePlayerView *)playerView didPlaybackStateChanged:(MPMoviePlaybackState)state
{
    switch (state) {
        case MPMoviePlaybackStatePlaying:
            [self pause];
            break;
        case MPMoviePlaybackStatePaused:
            [self prepareToPlay];
            [self play];
            break;
        default:
            break;
    }
}

@end
