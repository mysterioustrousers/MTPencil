//
//  MTShape.h
//  MTShapes
//
//  Created by Adam Kirk on 9/1/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

@class MTPencil;
typedef void (^MTPencilBlock)(MTPencil *pencil);

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
    MTPencilSpeedVerySlow   = 100,
    MTPencilSpeedSlow       = 400,
    MTPencilSpeedMedium     = 600,
    MTPencilSpeedFast       = 800,
    MTPencilSpeedVeryFast   = 1000
} MTPencilSpeed;






@interface MTPencil : NSObject

@property (nonatomic) NSUInteger framesPerSecond;


+ (MTPencil *)pencilDrawingInView:(UIView *)view;


#pragma mark - Moving

- (void)moveTo:(CGPoint)point;
- (void)moveAtAngle:(MTPencilAngle)angle distance:(CGFloat)distance;


#pragma mark - Drawing

- (void)drawTo:(CGPoint)point speed:(MTPencilSpeed)speed;
- (void)drawAtAngle:(MTPencilAngle)angle distance:(CGFloat)distance speed:(MTPencilSpeed)speed;
//- (void)drawToEdgeAtAngle:(MTPencilAngle)angle inset:(CGFloat)inset speed:(MTPencilSpeed)speed;


#pragma mark - Implement

- (void)beginWithCompletion:(MTPencilBlock)completion; // call this to begin drawing the shape
- (void)drawInContext:(CGContextRef)context; // You MUST call this from within the drawRect: function of the view you want to draw in.


#pragma mark - Helpers

+ (MTPencilSpeed)speedForDuration:(NSTimeInterval)duration overDistance:(CGFloat)distance;
+ (NSTimeInterval)durationForSpeed:(MTPencilSpeed)speed overDistance:(CGFloat)distance;


@end
