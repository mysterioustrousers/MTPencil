//
//  MTPencilDrawingStep.h
//  MTPencil
//
//  Created by Adam Kirk on 9/23/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

@class MTPencil;


typedef NS_ENUM(NSUInteger, MTPencilStepType) {
	MTPencilStepTypeMove,
	MTPencilStepTypeDraw
};


typedef NS_ENUM(NSInteger, MTPencilStepAngle) {
    MTPencilStepAngleUp           = -90,
    MTPencilStepAngleDown         = 90,
    MTPencilStepAngleLeft         = 180,
    MTPencilStepAngleRight        = 0,
    MTPencilStepAngleUpRight      = -45,
    MTPencilStepAngleUpLeft       = -135,
    MTPencilStepAngleDownRight    = 45,
    MTPencilStepAngleDownLeft     = 135
};

// Pencil speed is in points per second (PPS). On a standard resolution a point is a pixel, on a retina display, a point is 2 pixels.
typedef NS_ENUM(NSUInteger, MTPencilStepSpeed) {
    MTPencilStepSpeedVerySlow   = 100,
    MTPencilStepSpeedSlow       = 400,
    MTPencilStepSpeedMedium     = 600,
    MTPencilStepSpeedFast       = 800,
    MTPencilStepSpeedVeryFast   = 1000
};



@interface MTPencilStep : CAShapeLayer

@property (nonatomic, assign) MTPencilStepType type;
@property (nonatomic, assign) CGPoint          startPoint;
@property (nonatomic, assign) CGPoint          endPoint;
@property (nonatomic, assign) CGFloat          angle;
@property (nonatomic, assign) CGFloat          distance;
@property (nonatomic, assign) UIRectEdge       toEdge;
@property (nonatomic, assign) CGFloat          inset;
@property (nonatomic, assign) NSTimeInterval   delay;
@property (nonatomic, assign) CGFloat          animationSpeed;
@property (nonatomic, assign) CGFloat          animationDuration;
@property (nonatomic, assign) CGPathRef        appendPath;
@property (nonatomic, copy) void             (^completion)(MTPencilStep *step);


///-----------------------------------------
/// Destination
///-----------------------------------------

- (MTPencilStep *)to:(CGPoint)point;


- (MTPencilStep *)angle:(CGFloat)angle distance:(CGFloat)distance;

- (MTPencilStep *)up:(CGFloat)distance;

- (MTPencilStep *)down:(CGFloat)distance;

- (MTPencilStep *)left:(CGFloat)distance;

- (MTPencilStep *)right:(CGFloat)distance;

- (MTPencilStep *)toEdge:(UIRectEdge)edge;

- (MTPencilStep *)inset:(CGFloat)inset;


///------------------------------------------
/// Adding Paths
///------------------------------------------

- (MTPencilStep *)path:(CGPathRef)path;


///------------------------------------------
/// Speed (inherited by proceeding steps)
///------------------------------------------

- (MTPencilStep *)speed:(CGFloat)speed;

- (MTPencilStep *)duration:(NSTimeInterval)duration;


///------------------------------------------
/// Appearance (inherited by proceeding steps)
///------------------------------------------

- (MTPencilStep *)color:(UIColor *)color;

- (MTPencilStep *)width:(CGFloat)width;


///------------------------------------------
/// Misc.
///------------------------------------------

- (MTPencilStep *)delay:(NSTimeInterval)delay;

- (MTPencilStep *)completion:(void (^)(MTPencilStep *step))completion;

- (void)eraseWithCompletion:(void (^)(MTPencilStep *step))completion;

@end
