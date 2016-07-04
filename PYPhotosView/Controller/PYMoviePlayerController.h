//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//


#import <MediaPlayer/MediaPlayer.h>
@class PYMoviePlayerView, ASIHTTPRequest;

@interface PYMoviePlayerController : MPMoviePlayerController
{
    ASIHTTPRequest *videoRequest;
    unsigned long long Recordull;
    BOOL isPlay;
}
@property (nonatomic, weak) PYMoviePlayerView *playView;

@property (nonatomic, weak) UIImageView *playButtonView;

@end
