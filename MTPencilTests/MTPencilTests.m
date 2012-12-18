//
//  MTShapesTests.m
//  MTShapesTests
//
//  Created by Adam Kirk on 9/1/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "MTPencilTests.h"
#import "MTPencil.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation MTShapesTests

- (void)setUp
{
    [super setUp];
}

- (void)testRectIntersect
{
	CGRect rect = CGRectMake(100, 100, 100, 100);
	MTPencil *pencil = [MTPencil pencilWithBoundingRect:rect redrawBlock:nil];

	CGPoint start = CGPointMake(150, 150);
	CGPoint end	= CGPointMake(160, 160);
	CGPoint intersection = [pencil pointWhereLineFromPoint:start toPoint:end intersectsRect:rect];
	STAssertTrue(CGPointEqualToPoint(intersection, CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))), nil);

	start = CGPointMake(120, 120);
	end = CGPointMake(140, 160);
	intersection = [pencil pointWhereLineFromPoint:start toPoint:end intersectsRect:rect];
	STAssertTrue(CGPointEqualToPoint(intersection, CGPointMake(CGRectGetMinX(rect) + 60, CGRectGetMaxY(rect))), nil);

	start = CGPointMake(240, 100);
	end = CGPointMake(220, 140);
	intersection = [pencil pointWhereLineFromPoint:start toPoint:end intersectsRect:rect];
	STAssertTrue(CGPointEqualToPoint(intersection, CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect) + 80 )), nil);
}

@end
