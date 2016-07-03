//
//  PYMoviePlayerView.h
//  80-MPMoviePlayerController的简单使用
//
//  Created by 谢培艺 on 16/6/30.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYMoviePlayerController.h"
@class PYMoviePlayerView;
@protocol PYMoviePlayerViewDelegate <NSObject>

@optional
- (void)movicePlayerView:(PYMoviePlayerView *)playerView didPlaybackStateChanged:(MPMoviePlaybackState)state;

@end

@interface PYMoviePlayerView : UIView

/** 视频封面 */
@property (nonatomic, strong) UIImage *movieImage;

@property (nonatomic, weak) id<PYMoviePlayerViewDelegate> delegate;

+ (instancetype)moviePlayerView;

@end
