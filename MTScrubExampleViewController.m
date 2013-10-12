//
//  MTScrubExampleViewController.m
//  MTPencil
//
//  Created by Adam Kirk on 10/9/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MTScrubExampleViewController.h"
#import "MTPencil.h"


@interface MTScrubExampleViewController ()
@property (nonatomic, strong)          MTPencil *pencil;
@property (nonatomic, weak  ) IBOutlet UISlider *slider;
@end


@implementation MTScrubExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	_pencil = [MTPencil pencilWithView:self.view];
    [self setupCurves];
}



#pragma mark - Actions

- (IBAction)scrubSliderDidChange:(UISlider *)sender
{
    [_pencil scrub:sender.value];
}

- (IBAction)segmentedControlChanged:(UISegmentedControl *)sender
{
    [_pencil reset];
    if (sender.selectedSegmentIndex == 0) {
        [self setupCurves];
    }
    else if (sender.selectedSegmentIndex == 1) {
        [self setupText];
    }
    [_pencil scrub:_slider.value];
}



#pragma mark - Private

- (void)setupCurves
{
    CGRect frame = CGRectMake(0, 90, 290, 289);
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 111.5, CGRectGetMinY(frame) + 178.5)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 47.5, CGRectGetMinY(frame) + 127.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 84.5, CGRectGetMinY(frame) + 179.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 47.5, CGRectGetMinY(frame) + 127.5)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 67.5, CGRectGetMinY(frame) + 81.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 47.5, CGRectGetMinY(frame) + 127.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 35.32, CGRectGetMinY(frame) + 21.56)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 120.5, CGRectGetMinY(frame) + 108.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 99.68, CGRectGetMinY(frame) + 141.44) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 140.56, CGRectGetMinY(frame) + 160.44)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 137.5, CGRectGetMinY(frame) + 36.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 100.44, CGRectGetMinY(frame) + 56.56) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 108.58, CGRectGetMinY(frame) - 41.99)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 202.5, CGRectGetMinY(frame) + 253.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 166.42, CGRectGetMinY(frame) + 114.99) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 193.71, CGRectGetMinY(frame) + 361.46)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 166.5, CGRectGetMinY(frame) + 84.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 211.29, CGRectGetMinY(frame) + 145.54) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 141.25, CGRectGetMinY(frame) + 87.96)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 191.5, CGRectGetMinY(frame) + 29.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 191.75, CGRectGetMinY(frame) + 81.04) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 217.32, CGRectGetMinY(frame) + 35.41)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 247.5, CGRectGetMinY(frame) + 16.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 165.68, CGRectGetMinY(frame) + 23.59) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 253.95, CGRectGetMinY(frame) + 2.74)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 198.5, CGRectGetMinY(frame) + 90.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 241.05, CGRectGetMinY(frame) + 30.26) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 199.96, CGRectGetMinY(frame) + 46.94)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 217.5, CGRectGetMinY(frame) + 255.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 197.04, CGRectGetMinY(frame) + 134.06) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 217.08, CGRectGetMinY(frame) + 247.94)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 273.5, CGRectGetMinY(frame) + 144.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 217.92, CGRectGetMinY(frame) + 263.06) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 302.26, CGRectGetMinY(frame) + 183.11)];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 240.5, CGRectGetMinY(frame) + 169.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 244.74, CGRectGetMinY(frame) + 105.89) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 240.5, CGRectGetMinY(frame) + 169.5)];
    [[_pencil draw] path:bezierPath.CGPath];
}

- (void)setupText
{
    [[_pencil move] to:CGPointMake(10, 100)];
    [[[_pencil draw] string:@"Mysterious\nTrousers"] font:[UIFont fontWithName:@"HelveticaNeue" size:60]];
}



@end
