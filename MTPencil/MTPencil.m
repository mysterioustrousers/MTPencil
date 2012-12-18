//
//  MTShape.m
//  MTShapes
//
//  Created by Adam Kirk on 9/1/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "MTPencil.h"
#import <MTGeometry.h>



typedef enum {
	MTDrawingStepTypeMove,
	MTDrawingStepTypeDraw
} MTDrawingStepType;

typedef enum {
	MTDrawingStepDestinationTypeAbsolute,
    MTDrawingStepDestinationTypeRelative
} MTDrawingStepDestinationType;







@interface MTDrawingStep : NSObject
@property (weak, nonatomic) MTPencil                        *pencil;
@property (nonatomic)       MTDrawingStepType               type;
@property (nonatomic)       MTDrawingStepDestinationType	endType;
// Absolute
@property (nonatomic)       CGPoint                         endPoint;
// Relative
@property (nonatomic)       CGFloat                         angle;
@property (nonatomic)       CGFloat                         length;
@property (nonatomic)       CGFloat                         inset;			// currently only used for drawing to edge
// Animation (set at draw time)
@property (nonatomic)       CGPoint                         startPoint;
@property (nonatomic)       CGPoint                         currentPoint;
@property (nonatomic)       NSUInteger                      currentFrame;
@property (nonatomic)       NSUInteger                      totalFrames;
@property (nonatomic)       BOOL                            finished;
@property (nonatomic)       MTPencilSpeed                   speed;
@property (strong)          MTPencilBlock                   completion;
@end




@implementation MTDrawingStep

- (id)init
{
    self = [super init];
    if (self) {
		_type					= MTDrawingStepTypeMove;
		_endType				= MTDrawingStepDestinationTypeAbsolute;

		_endPoint				= CGPointZero;

		_angle					= 0;
		_length					= 0;
		_inset					= 0;
		
		_startPoint				= CGPointZero;
		_currentPoint			= CGPointZero;
		_currentFrame			= 1;
		_totalFrames			= 1;
		_finished				= NO;
		_speed                  = 0;
		_completion				= nil;
    }
    return self;
}

- (void)setStartPoint:(CGPoint)startPoint
{
	_startPoint		= startPoint;
	_currentPoint	= startPoint;
	if (_endType == MTDrawingStepDestinationTypeAbsolute) {
		_length = CGPointDistance(startPoint, _endPoint);
        if (_type == MTDrawingStepTypeDraw) {
            NSTimeInterval duration = [MTPencil durationForSpeed:_speed overDistance:_length];
            _totalFrames = duration * _pencil.framesPerSecond;
        }
	}
}

- (void)setEndPoint:(CGPoint)endPoint
{
    _endPoint = endPoint;
    if (_endType == MTDrawingStepDestinationTypeRelative) {
        _length = CGPointDistance(_startPoint, endPoint);
        if (_type == MTDrawingStepTypeDraw) {
            NSTimeInterval duration = [MTPencil durationForSpeed:_speed overDistance:_length];
            _totalFrames = duration * _pencil.framesPerSecond;
        }
    }
}

@end


















@interface MTPencil ()
@property (strong, nonatomic)   UIView              *view;
@property (strong, nonatomic)	NSMutableArray		*steps;
@property (nonatomic)			CGPoint				currentStartPoint;
@property (nonatomic)			dispatch_queue_t	queue;
@property (nonatomic, strong)	MTPencilBlock		completionBlock;
@end




@implementation MTPencil


- (id)initDrawingView:(UIView *)view
{
    self = [super init];
    if (self) {
        _view               = view;
		_steps				= [NSMutableArray array];
		_completionBlock	= nil;
        _framesPerSecond    = 60.0;
        _currentStartPoint  = CGPointZero;
    }
    return self;
}

+ (MTPencil *)pencilDrawingInView:(UIView *)view
{
	return [[MTPencil alloc] initDrawingView:view];
}

- (void)beginWithCompletion:(MTPencilBlock)completion
{
	_completionBlock = completion;
    [_view setNeedsDisplay];
}




#pragma mark Moving

- (void)moveTo:(CGPoint)point
{
	MTDrawingStep *step = [[MTDrawingStep alloc] init];
    step.pencil         = self;
	step.type			= MTDrawingStepTypeMove;
	step.endType		= MTDrawingStepDestinationTypeAbsolute;
	step.endPoint		= point;
	[_steps addObject:step];
}

- (void)moveAtAngle:(CGFloat)angle distance:(CGFloat)distance;
{
	MTDrawingStep *step	= [[MTDrawingStep alloc] init];
    step.pencil     = self;
	step.type		= MTDrawingStepTypeMove;
	step.endType	= MTDrawingStepDestinationTypeRelative;
	step.angle		= angle;
	step.length		= distance;
	[_steps addObject:step];
}






#pragma mark Drawing

- (void)drawTo:(CGPoint)point speed:(MTPencilSpeed)speed
{
	MTDrawingStep *step	= [[MTDrawingStep alloc] init];
    step.pencil     = self;
	step.type		= MTDrawingStepTypeDraw;
	step.endType	= MTDrawingStepDestinationTypeAbsolute;
	step.endPoint	= point;
	step.speed      = speed;
	[_steps addObject:step];
}

- (void)drawAtAngle:(MTPencilAngle)angle distance:(CGFloat)distance speed:(MTPencilSpeed)speed
{
	MTDrawingStep *step	= [[MTDrawingStep alloc] init];
    step.pencil     = self;
	step.type		= MTDrawingStepTypeDraw;
	step.endType	= MTDrawingStepDestinationTypeRelative;
	step.angle		= angle;
	step.length		= distance;
	step.speed      = speed;
	[_steps addObject:step];
}

- (void)drawToEdgeAtAngle:(MTPencilAngle)angle inset:(CGFloat)inset speed:(MTPencilSpeed)speed
{
	MTDrawingStep *step	= [[MTDrawingStep alloc] init];
    step.pencil     = self;
	step.type		= MTDrawingStepTypeDraw;
	step.endType	= MTDrawingStepDestinationTypeRelative;
	step.angle		= angle;
	step.length		= INFINITY;
	step.inset		= inset;
	step.speed      = speed;
	[_steps addObject:step];
}





- (void)drawInContext:(CGContextRef)context
{
//    CGContextRef context = UIGraphicsGetCurrentContext(); // Won't work on Mac, need to switch to NSBezierPath

	CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);

	for (MTDrawingStep *step in _steps) {

		step.startPoint = _currentStartPoint;
		CGContextMoveToPoint(context, step.startPoint.x, step.startPoint.y);

        if (step.endType == MTDrawingStepDestinationTypeRelative && step.currentFrame == 1) {
            CGPoint endPoint;
            endPoint = CGPointMake(step.startPoint.x + step.length, step.startPoint.y);
            endPoint = CGPointRotatedAroundPoint(endPoint, step.startPoint, step.angle);
            step.endPoint = endPoint;
        }

		CGFloat stepLength	= step.length / step.totalFrames;

		CGPoint nextPoint;
        if (stepLength  > 0)
            nextPoint = CGPointAlongLine(CGLineMake(step.startPoint, step.endPoint), (stepLength * step.currentFrame));
        else
            nextPoint = step.currentPoint;

        if (step.type == MTDrawingStepTypeDraw) {
            CGContextAddLineToPoint(context, nextPoint.x, nextPoint.y);
        }
        else if (step.type == MTDrawingStepTypeMove){
            CGContextMoveToPoint(context, nextPoint.x, nextPoint.y);
        }

		step.currentPoint = nextPoint;

		step.finished = step.currentFrame == step.totalFrames;

		if (step.finished) {
			_currentStartPoint = step.currentPoint;
		}
		else {
			step.currentFrame++;
			break;
		}
	}

	CGContextStrokePath(context);

	MTDrawingStep *lastStep = _steps.lastObject;
	if (lastStep && !lastStep.finished) {
		[NSTimer scheduledTimerWithTimeInterval:(1.0 / _framesPerSecond) target:self selector:@selector(timerTicked) userInfo:nil repeats:NO];
	}
	else {
		if (_completionBlock) _completionBlock(self);
	}

}




#pragma mark Helpers

+ (MTPencilSpeed)speedForDuration:(NSTimeInterval)duration overDistance:(CGFloat)distance
{
    return distance / duration;
}

+ (NSTimeInterval)durationForSpeed:(MTPencilSpeed)speed overDistance:(CGFloat)distance
{
    return distance / speed;
}




#pragma mark - Private Methods

- (void)timerTicked
{
	[_view setNeedsDisplay];
}



@end
