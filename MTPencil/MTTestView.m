//
//  MTTestView.m
//  MTShapes
//
//  Created by Adam Kirk on 9/1/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "MTTestView.h"
#import "MTPencil.h"

#define PPS 800




@interface MTTestView ()
@property (nonatomic, strong) MTPencil *pencil;
@end




@implementation MTTestView


- (void)draw
{
    MTPencilStepSpeed speed = 100;

	_pencil = [MTPencil pencilWithView:self];

	[[_pencil move] to:CGPointMake(100, 100)];
	[[[_pencil draw] angle:MTPencilStepAngleUpRight distance:20]    speed:speed];
	[[[_pencil draw] angle:MTPencilStepAngleUp      distance:50]    speed:10];
	[[[_pencil draw] angle:MTPencilStepAngleRight   distance:100]	speed:speed];
	[[[_pencil draw] angle:MTPencilStepAngleDown    distance:200]	speed:speed];
	[[[_pencil draw] angle:MTPencilStepAngleLeft	distance:100]	speed:speed];
	[[[_pencil draw] angle:MTPencilStepAngleUp      distance:123]	speed:speed];
	[[[_pencil draw] angle:MTPencilStepAngleUpLeft  distance:20]    speed:speed];
    [[[_pencil draw] to:CGPointMake(200, 200)]                      speed:speed];
	[_pencil beginWithCompletion:^(MTPencil *pencil) {

    }];
}


@end
