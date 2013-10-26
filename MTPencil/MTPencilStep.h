//
//  MTPencilDrawingStep.h
//  MTPencil
//
//  Created by Adam Kirk on 9/23/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MTPencilEasingFunctions.h"


@class MTPencil;


typedef NS_ENUM(NSUInteger, MTPencilStepState) {
    MTPencilStepStateNotStarted,
    MTPencilStepStateDrawing,
    MTPencilStepStateDrawn,
    MTPencilStepStateErasing
};


typedef NS_ENUM(NSUInteger, MTPencilStepType) {
    MTPencilStepTypeConfig,
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

/**
 * Pencil speed is in points per second (PPS). On a standard
 * resolution a point is a pixel, on a retina display, a point is 2 pixels.
 */
typedef NS_ENUM(NSUInteger, MTPencilStepSpeed) {
    MTPencilStepSpeedVerySlow   = 100,
    MTPencilStepSpeedSlow       = 400,
    MTPencilStepSpeedMedium     = 600,
    MTPencilStepSpeedFast       = 800,
    MTPencilStepSpeedVeryFast   = 1000
};



@interface MTPencilStep : CAShapeLayer

@property (nonatomic, assign, readonly) MTPencilStepType       type;
@property (nonatomic, assign, readonly) MTPencilStepState      state;
@property (nonatomic, assign          ) CGPoint                startPoint;
@property (nonatomic, assign          ) CGPoint                endPoint;
@property (nonatomic, assign          ) CGFloat                angle;
@property (nonatomic, assign          ) CGFloat                distance;
@property (nonatomic, assign          ) UIRectEdge             toEdge;
@property (nonatomic, assign          ) CGFloat                inset;
@property (nonatomic, assign          ) NSTimeInterval         delay;
@property (nonatomic, assign          ) CGFloat                animationSpeed;
@property (nonatomic, assign          ) CGFloat                animationDuration;
@property (nonatomic, assign          ) CGPathRef              appendPath;
@property (nonatomic, assign, readonly) CGFloat                length;
@property (nonatomic, copy            ) NSAttributedString     *attributedString;
@property (nonatomic, assign          ) MTPencilEasingFunction easingFunction;
@property (nonatomic, copy            ) void                   (^completion)(MTPencilStep *step);
@property (nonatomic, copy            ) void                   (^eraseCompletion)(MTPencilStep *step);


///------------------------------------------
/// Controlling Playback
///------------------------------------------

- (void)drawWithCompletion:(void (^)(MTPencilStep *step))completion;

- (void)eraseWithCompletion:(void (^)(MTPencilStep *step))eraseCompletion;

- (void)scrub:(CGFloat)percent;

- (void)finish;

- (void)erase;


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
/// Adding Text
///------------------------------------------

- (MTPencilStep *)string:(NSString *)string;

- (MTPencilStep *)attributedString:(NSAttributedString *)attributedString;


///------------------------------------------
/// Speed (Inherited by Proceeding Steps)
///------------------------------------------

- (MTPencilStep *)speed:(CGFloat)speed;

- (MTPencilStep *)duration:(NSTimeInterval)duration;

- (MTPencilStep *)easingFunction:(MTPencilEasingFunction)easingFunction;


///------------------------------------------
/// Appearance (Inherited by Proceeding Steps)
///------------------------------------------

- (MTPencilStep *)strokeColor:(UIColor *)color;

- (MTPencilStep *)width:(CGFloat)width;

- (MTPencilStep *)font:(UIFont *)font;


///------------------------------------------
/// Misc
///------------------------------------------

- (MTPencilStep *)delay:(NSTimeInterval)delay;


///------------------------------------------
/// Getting Generated Paths
///------------------------------------------

- (CGPathRef)CGPath;


@end
