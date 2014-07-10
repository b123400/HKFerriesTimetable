//
//  BRClockView.h
//  ferriestimetable2
//
//  Created by b123400 on 11/7/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BRClockLayer : CALayer

@property (nonatomic) CGFloat startAngle;
@property (nonatomic) CGFloat endAngle;

@property (nonatomic, strong) UIColor *fillColor;

@end