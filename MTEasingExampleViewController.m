//
//  MTMorphViewController.m
//  MTPencil
//
//  Created by Adam Kirk on 10/10/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MTEasingExampleViewController.h"
#import "MTPencil.h"


@interface MTEasingExampleViewController ()
@property (nonatomic, strong)          MTPencil *pencil;
@property (nonatomic, weak  ) IBOutlet UIButton *drawButton;
@property (nonatomic, weak  ) IBOutlet UIButton *reverseButton;
@end


@implementation MTEasingExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.reverseButton.enabled = NO;

	_pencil = [MTPencil pencilWithView:self.view];

	[[[_pencil move] to:CGPointMake(100, 150)] duration:1];
	[[[_pencil draw] angle:MTPencilStepAngleUpRight    distance:20]     easingFunction:kMTEaseOutBounce];
	[[[_pencil draw] angle:MTPencilStepAngleUp         distance:50]     easingFunction:kMTEaseInExpo];
	[[[_pencil draw] angle:MTPencilStepAngleRight      distance:100]	easingFunction:kMTEaseInOutExpo];
    [[[_pencil draw] angle:MTPencilStepAngleDown       distance:200]	easingFunction:kMTEaseInBounce];
	[[[_pencil draw] angle:MTPencilStepAngleLeft       distance:100]	easingFunction:kMTEaseOutElastic];
	[[[_pencil draw] angle:MTPencilStepAngleUp         distance:123]	easingFunction:kMTEaseInOutExpo];
	[[[_pencil draw] angle:MTPencilStepAngleUpLeft     distance:20]     easingFunction:kMTEaseLinear];


    CGRect frame = CGRectMake(0, 150, 290, 289);
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(CGRectGetMinX(frame) + 111.5, CGRectGetMinY(frame) + 178.5)];
    [bezierPath addCurveToPoint:CGPointMake(CGRectGetMinX(frame) + 47.5, CGRectGetMinY(frame) + 127.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 84.5, CGRectGetMinY(frame) + 179.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 47.5, CGRectGetMinY(frame) + 127.5)];
    [bezierPath addCurveToPoint:CGPointMake(CGRectGetMinX(frame) + 67.5, CGRectGetMinY(frame) + 81.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 47.5, CGRectGetMinY(frame) + 127.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 35.32, CGRectGetMinY(frame) + 21.56)];
    [bezierPath addCurveToPoint:CGPointMake(CGRectGetMinX(frame) + 120.5, CGRectGetMinY(frame) + 108.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 99.68, CGRectGetMinY(frame) + 141.44) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 140.56, CGRectGetMinY(frame) + 160.44)];
    [bezierPath addCurveToPoint:CGPointMake(CGRectGetMinX(frame) + 137.5, CGRectGetMinY(frame) + 36.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 100.44, CGRectGetMinY(frame) + 56.56) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 108.58, CGRectGetMinY(frame) - 41.99)];
    [bezierPath addCurveToPoint:CGPointMake(CGRectGetMinX(frame) + 202.5, CGRectGetMinY(frame) + 253.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 166.42, CGRectGetMinY(frame) + 114.99) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 193.71, CGRectGetMinY(frame) + 361.46)];
    [bezierPath addCurveToPoint:CGPointMake(CGRectGetMinX(frame) + 166.5, CGRectGetMinY(frame) + 84.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 211.29, CGRectGetMinY(frame) + 145.54) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 141.25, CGRectGetMinY(frame) + 87.96)];
    [bezierPath addCurveToPoint:CGPointMake(CGRectGetMinX(frame) + 191.5, CGRectGetMinY(frame) + 29.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 191.75, CGRectGetMinY(frame) + 81.04) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 217.32, CGRectGetMinY(frame) + 35.41)];
    [bezierPath addCurveToPoint:CGPointMake(CGRectGetMinX(frame) + 247.5, CGRectGetMinY(frame) + 16.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 165.68, CGRectGetMinY(frame) + 23.59) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 253.95, CGRectGetMinY(frame) + 2.74)];
    [bezierPath addCurveToPoint:CGPointMake(CGRectGetMinX(frame) + 198.5, CGRectGetMinY(frame) + 90.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 241.05, CGRectGetMinY(frame) + 30.26) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 199.96, CGRectGetMinY(frame) + 46.94)];
    [bezierPath addCurveToPoint:CGPointMake(CGRectGetMinX(frame) + 217.5, CGRectGetMinY(frame) + 255.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 197.04, CGRectGetMinY(frame) + 134.06) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 217.08, CGRectGetMinY(frame) + 247.94)];
    [bezierPath addCurveToPoint:CGPointMake(CGRectGetMinX(frame) + 273.5, CGRectGetMinY(frame) + 144.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 217.92, CGRectGetMinY(frame) + 263.06) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 302.26, CGRectGetMinY(frame) + 183.11)];
    [bezierPath addCurveToPoint:CGPointMake(CGRectGetMinX(frame) + 240.5, CGRectGetMinY(frame) + 169.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 244.74, CGRectGetMinY(frame) + 105.89) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 240.5, CGRectGetMinY(frame) + 169.5)];
    [[[[_pencil draw] path:bezierPath.CGPath] easingFunction:kMTEaseOutExpo] duration:4];
}



#pragma mark - Actions

- (IBAction)drawButtonPressed:(UIButton *)sender
{
    self.drawButton.enabled     = NO;
    self.reverseButton.enabled  = NO;
    [_pencil erase];
	[_pencil beginWithCompletion:^(MTPencil *pencil) {
        self.drawButton.enabled     = YES;
        self.reverseButton.enabled  = YES;
    }];
}

- (IBAction)reverseButtonWasTapped:(id)sender
{
    self.drawButton.enabled     = NO;
    self.reverseButton.enabled  = NO;
    [_pencil eraseWithCompletion:^(MTPencil *pencil) {
        self.drawButton.enabled     = YES;
        self.reverseButton.enabled  = YES;
    }];
}

@end
