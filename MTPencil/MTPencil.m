//
//  MTShape.m
//  MTShapes
//
//  Created by Adam Kirk on 9/1/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "MTPencil.h"
#import <MTGeometry.h>

#define FPS			60.0
#define INTERVAL	(1.0 / FPS)



typedef enum {
	MTDrawingStepTypeMove,
	MTDrawingStepTypeDraw
} MTDrawingStepType;

typedef enum {
	MTDrawingStepEndTypeAbsolute,
	MTDrawingStepEndTypeRelative
} MTDrawingStepEndType;







@interface MTDrawingStep : NSObject
@property (nonatomic)	MTDrawingStepType			type;
@property (nonatomic)	MTDrawingStepEndType		endType;
// Absolute
@property (nonatomic)	CGPoint						endPoint;
// Relative
@property (nonatomic)	CGFloat						angle;
@property (nonatomic)	CGFloat						length;
@property (nonatomic)	CGFloat						inset;			// currently only used for drawing to edge
// Animation (set at draw time)
@property (nonatomic)	CGPoint						startPoint;
@property (nonatomic)	CGPoint						currentPoint;
@property (nonatomic)	NSUInteger					currentFrame;
@property (nonatomic)	NSUInteger					totalFrames;
@property (nonatomic)	BOOL						finished;
@property (nonatomic)	NSTimeInterval				duration;
@property (strong)		MTPencilBlock				completion;
@end




@implementation MTDrawingStep

- (id)init
{
    self = [super init];
    if (self) {
		_type					= MTDrawingStepTypeMove;
		_endType				= MTDrawingStepEndTypeAbsolute;

		_endPoint				= CGPointZero;

		_angle					= 0;
		_length					= 0;
		_inset					= 0;
		
		_startPoint				= CGPointZero;
		_currentPoint			= CGPointZero;
		_currentFrame			= 1;
		_totalFrames			= 1;
		_finished				= NO;
		_duration				= 0;
		_completion				= nil;
    }
    return self;
}

- (void)setDuration:(NSTimeInterval)duration
{
	_duration		= duration;
	_totalFrames	= round(duration * FPS);
}

- (void)setStartPoint:(CGPoint)startPoint
{
	_startPoint		= startPoint;
	_currentPoint	= startPoint;
	if (_endType == MTDrawingStepEndTypeAbsolute) {
		_length = CGPointDistance(startPoint, _endPoint);
	}
}

@end


















@interface MTPencil ()
@property (nonatomic)			CGRect				boundingRect;
@property (nonatomic, strong)	MTPencilBlock		redrawBlock;
@property (strong, nonatomic)	NSMutableArray		*steps;
@property (nonatomic)			CGPoint				currentPoint;
@property (nonatomic)			dispatch_queue_t	queue;
@property (nonatomic, strong)	MTPencilBlock		completionBlock;
@end




@implementation MTPencil


- (id)initWithBoundingRect:(CGRect)boundingRect redrawBlock:(MTPencilBlock)redrawBlock
{
    self = [super init];
    if (self) {
		_boundingRect		= boundingRect;
		_steps				= [NSMutableArray array];
        _redrawBlock		= redrawBlock;
		_completionBlock	= nil;
    }
    return self;
}

+ (MTPencil *)pencilWithBoundingRect:(CGRect)boundingRect redrawBlock:(MTPencilBlock)redrawBlock
{
	return [[MTPencil alloc] initWithBoundingRect:boundingRect redrawBlock:redrawBlock];
}

- (void)beginWithCompletion:(MTPencilBlock)completion
{
	_completionBlock = completion;
	_redrawBlock();
}




#pragma mark Moving

- (void)moveTo:(CGPoint)point
{
	MTDrawingStep *step = [[MTDrawingStep alloc] init];
	step.type			= MTDrawingStepTypeMove;
	step.endType		= MTDrawingStepEndTypeAbsolute;
	step.endPoint		= point;
	[_steps addObject:step];
}

- (void)moveAtAngle:(CGFloat)angle distance:(CGFloat)distance;
{
	MTDrawingStep *step	= [[MTDrawingStep alloc] init];
	step.type		= MTDrawingStepTypeMove;
	step.endType	= MTDrawingStepEndTypeRelative;
	step.angle		= angle;
	step.length		= distance;
	[_steps addObject:step];
}






#pragma mark Drawing

- (void)drawTo:(CGPoint)point duration:(NSTimeInterval)duration
{
	MTDrawingStep *step	= [[MTDrawingStep alloc] init];
	step.type		= MTDrawingStepTypeDraw;
	step.endType	= MTDrawingStepEndTypeAbsolute;
	step.endPoint	= point;
	step.duration	= duration;
	[_steps addObject:step];
}

- (void)drawAtAngle:(MTPencilAngle)angle distance:(CGFloat)length speed:(MTPencilSpeed)speed
{
	MTDrawingStep *step	= [[MTDrawingStep alloc] init];
	step.type		= MTDrawingStepTypeDraw;
	step.endType	= MTDrawingStepEndTypeRelative;
	step.angle		= angle;
	step.length		= length;
	step.duration	= speed;
	[_steps addObject:step];
}

- (void)drawToEdgeAtAngle:(MTPencilAngle)angle inset:(CGFloat)inset speed:(MTPencilSpeed)speed
{
	MTDrawingStep *step	= [[MTDrawingStep alloc] init];
	step.type		= MTDrawingStepTypeDraw;
	step.endType	= MTDrawingStepEndTypeRelative;
	step.angle		= angle;
	step.length		= INFINITY;
	step.inset		= inset;
	step.duration	= speed;
	[_steps addObject:step];
}





- (void)updateInContext:(CGContextRef)context
{
	CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);

	for (MTDrawingStep *step in _steps) {

		step.startPoint = _currentPoint;
		CGContextMoveToPoint(context, step.startPoint.x, step.startPoint.y);

		CGFloat stepLength	= step.length / step.totalFrames;
		CGPoint nextPoint;

		if (step.endType == MTDrawingStepEndTypeAbsolute) {

            nextPoint = CGPointAlongLine(CGLineMake(step.startPoint, step.endPoint), (stepLength * step.currentFrame));

			if (step.type == MTDrawingStepTypeDraw) {
				CGContextAddLineToPoint(context, nextPoint.x, nextPoint.y);
			}
			else if (step.type == MTDrawingStepTypeMove){
				CGContextMoveToPoint(context, nextPoint.x, nextPoint.y);
			}
		}

		if (step.endType == MTDrawingStepEndTypeRelative) {

			// calculate next point
			nextPoint = CGPointMake(step.startPoint.x + (stepLength * step.currentFrame), step.startPoint.y);
            nextPoint = CGPointRotatedAroundPoint(nextPoint, step.startPoint, step.angle);

			if (step.type == MTDrawingStepTypeDraw) {
				CGContextAddLineToPoint(context, nextPoint.x, nextPoint.y);
			}
			else if (step.type == MTDrawingStepTypeMove){
				CGContextMoveToPoint(context, nextPoint.x, nextPoint.y);
			}

		}

		step.currentPoint = nextPoint;

		step.finished = step.currentFrame == step.totalFrames;

		if (step.finished) {
			_currentPoint = step.currentPoint;
		}
		else {
			step.currentFrame++;
			break;
		}
	}

	CGContextStrokePath(context);

	MTDrawingStep *lastStep = _steps.lastObject;
	if (lastStep && !lastStep.finished) {
		[NSTimer scheduledTimerWithTimeInterval:INTERVAL target:self selector:@selector(timerTicked) userInfo:nil repeats:NO];
	}
	else {
		if (_completionBlock) _completionBlock();
	}

}




#pragma mark Helpers

+ (NSInteger)speedForDuration:(NSTimeInterval)duration overDistance:(CGFloat)distance
{
    return distance / duration;
}




#pragma mark - Private Methods

- (void)timerTicked
{
	_redrawBlock();
}



@end
