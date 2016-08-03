//
//  PYDALabeledCircularProgressView.h
//  DACircularProgressExample
//
//  Created by Josh Sklar on 4/8/14.
//  Copyright (c) 2014 Shout Messenger. All rights reserved.
//  用于显示进度条的视图（带有文字）

#import "PYDACircularProgressView.h"

/**
 @class PYDALabeledCircularProgressView
 
 @brief Subclass of PYDACircularProgressView that adds a UILabel.
 */
@interface PYDALabeledCircularProgressView : PYDACircularProgressView

/**
 UILabel placed right on the PYDACircularProgressView.
 */
@property (strong, nonatomic) UILabel *progressLabel;

@end
