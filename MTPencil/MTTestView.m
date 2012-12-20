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
@property (strong) MTPencil *pencil;
@end




@implementation MTTestView


- (void)draw
{
    MTPencilSpeed speed = MTPencilSpeedVerySlow;

	_pencil = [MTPencil pencilDrawingInView:self];

	[_pencil moveTo:CGPointMake(100, 100)];
	[_pencil drawAtAngle:MTPencilAngleUpRight	distance:20     speed:speed];
	[_pencil drawAtAngle:MTPencilAngleUp		distance:50     speed:speed];
	[_pencil drawAtAngle:MTPencilAngleRight		distance:100	speed:speed];
	[_pencil drawAtAngle:MTPencilAngleDown		distance:200	speed:speed];
	[_pencil drawAtAngle:MTPencilAngleLeft		distance:100	speed:speed];
	[_pencil drawAtAngle:MTPencilAngleUp		distance:123	speed:speed];
	[_pencil drawAtAngle:MTPencilAngleUpLeft	distance:20     speed:speed];
    [_pencil drawTo:CGPointMake(200, 200) speed:speed];
	[_pencil beginWithCompletion:^(MTPencil *pencil) {

    }];
}

- (void)drawRect:(CGRect)rect
{
	[_pencil animate];
}


@end
