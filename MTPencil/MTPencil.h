//
//  MTShape.h
//  MTShapes
//
//  Created by Adam Kirk on 9/1/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//


typedef void (^MTPencilBlock)();

enum {
	MTPencilAngleUp			= -90,
	MTPencilAngleDown		= 90,
	MTPencilAngleLeft		= 180,
	MTPencilAngleRight		= 0,
	MTPencilAngleUpRight	= -45,
	MTPencilAngleUpLeft		= -135,
	MTPencilAngleDownRight	= 45,
	MTPencilAngleDownLeft	= 135
};
typedef CGFloat MTPencilAngle;


// Pencil speed is in points per second (PPS). On a standard resolution a point is a pixel, on a retina display, a point is 2 pixels.
typedef enum {
    MTPencilSpeedSlow       = 400,
    MTPencilSpeedMedium     = 600,
    MTPencilSpeedFast       = 800,
    MTPencilSpeedYES        = 1000
} MTPencilSpeed;






@interface MTPencil : NSObject


+ (MTPencil *)pencilWithBoundingRect:(CGRect)boundingRect redrawBlock:(MTPencilBlock)redrawBlock;
- (void)beginWithCompletion:(MTPencilBlock)completion; // call this to begin drawing the shape


#pragma mark - Moving

- (void)moveTo:(CGPoint)point;
- (void)moveAtAngle:(MTPencilAngle)angle distance:(CGFloat)distance;


#pragma mark - Drawing

- (void)drawTo:(CGPoint)point duration:(NSTimeInterval)duration;
- (void)drawAtAngle:(MTPencilAngle)angle distance:(CGFloat)length speed:(MTPencilSpeed)speed;
- (void)drawToEdgeAtAngle:(MTPencilAngle)angle inset:(CGFloat)inset speed:(MTPencilSpeed)speed;


#pragma mark - Implement

- (void)updateInContext:(CGContextRef)context; // You MUST call this from within the drawRect: function of the view you want to draw in.


#pragma mark - Helpers

+ (NSInteger)speedForDuration:(NSTimeInterval)duration overDistance:(CGFloat)distance;


@end
