//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PYMovie : NSObject

/** 视频路径 */
@property (nonatomic, copy) NSURL *url;

/** 视频时长 */
@property (nonatomic, assign) NSTimeInterval duration;

/** 记录最后一次播放时间位置 */
@property (nonatomic, assign) NSTimeInterval lastTime;

/** 播放视频是否快进了 */
@property (nonatomic, assign) BOOL skip;

@end
