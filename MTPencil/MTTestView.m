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


- (void)awakeFromNib
{
}

- (void)draw
{
	_pencil = [MTPencil pencilWithBoundingRect:self.frame redrawBlock:^{
		[self setNeedsDisplay];
	}];
	[_pencil moveTo:CGPointMake(100, 100)];
	[_pencil drawAtAngle:MTPencilAngleUpRight	distance:20     speed:PPS];
	[_pencil drawAtAngle:MTPencilAngleUp		distance:50     speed:PPS];
	[_pencil drawAtAngle:MTPencilAngleRight		distance:100	speed:PPS];
	[_pencil drawAtAngle:MTPencilAngleDown		distance:200	speed:PPS];
	[_pencil drawAtAngle:MTPencilAngleLeft		distance:100	speed:PPS];
	[_pencil drawAtAngle:MTPencilAngleUp		distance:123	speed:PPS];
	[_pencil drawAtAngle:MTPencilAngleUpLeft	distance:20     speed:PPS];
	[_pencil beginWithCompletion:^{

	}];
}

- (void)drawRect:(CGRect)rect
{
	[_pencil updateInContext:UIGraphicsGetCurrentContext()];
}


@end
