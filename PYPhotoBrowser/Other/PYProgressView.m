//  代码地址: https://github.com/iphone5solo/PYPhotosView
//  代码地址: http://code4app.com/thread-8612-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//  

#import "PYProgressView.h"

@implementation PYProgressView

- (instancetype)init
{
    if (self = [super init]) {
        [self initializeLabel];
    }
    return self;
}

- (void)py_setProgress:(CGFloat)progress animated:(BOOL)animated
{
    [super setProgress:progress animated:animated];
    
    // 设置文本
    self.progressLabel.text = [[NSString stringWithFormat:@"%.0f%%", progress * 100] stringByReplacingOccurrencesOfString:@"-" withString:@""];
}


#pragma mark - Internal methods

/**
 Creates and initializes
 -[PYDALabeledCircularProgressView progressLabel].
 */
- (void)initializeLabel
{
    self.progressLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.progressLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    self.progressLabel.backgroundColor = [UIColor clearColor];
    self.progressLabel.font = [UIFont systemFontOfSize:14];
    self.progressLabel.textColor = [UIColor whiteColor];
    self.roundedCorners = 10; // 设置圆角
    [self addSubview:self.progressLabel];
}

@end
