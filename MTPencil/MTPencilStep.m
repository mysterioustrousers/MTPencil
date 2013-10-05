//
//  MTPencilDrawingStep.m
//  MTPencil
//
//  Created by Adam Kirk on 9/23/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MTPencilStep.h"
#import "MTPencilStep_Private.h"


@implementation MTPencilStep {
    BOOL _isErasing;
}

- (id)init
{
    self = [super init];
    if (self) {
        _type                   = MTPencilStepTypeMove;

        // absolute
        _startPoint             = CGPointZero;
        _endPoint               = CGPointZero;

        // relative
        _angle                  = NULL_NUMBER;
        _distance               = NULL_NUMBER;

        // attributes
        _animationSpeed         = NULL_NUMBER;
        _animationDuration      = NULL_NUMBER;
        _completion             = nil;
        _inset                  = NULL_NUMBER;
        _delay                  = 0;
        _appendPath             = NULL;

        // private
        _destinationType        = MTPencilStepDestinationTypeAbsolute;
        _finished               = NO;

        _eraseCompletion        = nil;
        _isErasing              = NO;

        self.fillColor          = [UIColor clearColor].CGColor;
    }
    return self;
}

- (void)dealloc
{
    if (self.appendPath != NULL) {
        CFRelease(self.appendPath);
    }
}





#pragma mark - Public

#pragma mark (destination)

- (MTPencilStep *)to:(CGPoint)point
{
    _destinationType    = MTPencilStepDestinationTypeAbsolute;
    self.endPoint       = point;
    self.angle          = NULL_NUMBER;
    self.distance       = NULL_NUMBER;
    return self;
}

- (MTPencilStep *)angle:(CGFloat)angle distance:(CGFloat)distance
{
    assert(distance > 0);
    _destinationType    = MTPencilStepDestinationTypeRelative;
    self.angle          = angle;
    self.distance       = distance;
    self.endPoint       = NULL_POINT;
    return self;
}

- (MTPencilStep *)up:(CGFloat)distance
{
    return [self angle:MTPencilStepAngleUp distance:distance];
}

- (MTPencilStep *)down:(CGFloat)distance
{
    return [self angle:MTPencilStepAngleDown distance:distance];
}

- (MTPencilStep *)left:(CGFloat)distance
{
    return [self angle:MTPencilStepAngleLeft distance:distance];
}

- (MTPencilStep *)right:(CGFloat)distance
{
    return [self angle:MTPencilStepAngleRight distance:distance];
}

- (MTPencilStep *)toEdge:(UIRectEdge)edge
{
    assert(edge != UIRectEdgeNone && edge != UIRectEdgeAll);
    _destinationType    = MTPencilStepDestinationTypeRelative;
    self.toEdge         = edge;
    return self;
}

- (MTPencilStep *)inset:(CGFloat)inset
{
    self.inset = inset;
    return self;
}


#pragma mark (adding paths)

- (MTPencilStep *)path:(CGPathRef)path
{
    assert(path != NULL);
    CFRetain(path);
    self.appendPath = path;
    return self;
}


#pragma mark (speed)

- (MTPencilStep *)speed:(CGFloat)speed
{
    self.animationSpeed     = speed;
    self.animationDuration  = NULL_NUMBER;
    return self;
}

- (MTPencilStep *)duration:(NSTimeInterval)duration
{
    self.animationDuration  = duration;
    self.animationSpeed     = NULL_NUMBER;
    return self;
}

- (MTPencilStep *)delay:(NSTimeInterval)delay
{
    self.delay = delay;
    return self;
}



#pragma mark (appearance)

- (MTPencilStep *)color:(UIColor *)color
{
    self.strokeColor = color.CGColor;
    return self;
}

- (MTPencilStep *)width:(CGFloat)width
{
    self.lineWidth = width;
    return self;
}


#pragma mark (misc)

- (MTPencilStep *)completion:(void (^)(MTPencilStep *))completion
{
    self.completion = completion;
    return self;
}




#pragma mark - DELEGATE CAAnimation

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (_isErasing) {
        self.finished = NO;
        if (_eraseCompletion) _eraseCompletion(self);
        [self.delegate pencilStep:self didErase:YES];
        _isErasing = NO;
    }
    else {
        self.finished = YES;
        if (self.completion) self.completion(self);
        [self.delegate pencilStep:self didFinish:YES];
    }
}




#pragma mark - Protected

- (void)inheritFromStep:(MTPencilStep *)step
{
    if (self.animationSpeed == NULL_NUMBER) {
        self.animationSpeed = step.animationSpeed;
    }

    if (self.animationDuration == NULL_NUMBER) {
        self.animationDuration = step.animationDuration;
    }

    if (!self.strokeColor) {
        self.strokeColor = step.strokeColor;
    }

    if (self.lineWidth == 1) {
        self.lineWidth = step.lineWidth;
    }
}

- (void)startFromPoint:(CGPoint)point animated:(BOOL)animated
{
    if (self.finished) {
        [self.delegate pencilStep:self didFinish:YES];
        return;
    }

    if (!animated) {
        self.startPoint = point;
        [self calculateMissingValues];
        [self generatePath];
        self.finished = YES;
        [self.delegate pencilStep:self didFinish:YES];
    }

    double delayInSeconds = self.delay;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        if (![self isEnoughValuesSetToDraw]) {
            [self.delegate pencilStep:self didFinish:YES];
            return;
        }

        self.startPoint = point;
        [self calculateMissingValues];

        if (self.type == MTPencilStepTypeDraw) {
            [self generatePath];
            [self draw];
        }
        else if (self.type == MTPencilStepTypeMove) {
            self.finished = YES;
            [self.delegate pencilStep:self didFinish:YES];
        }
    });
}

- (void)eraseWithCompletion:(void (^)(MTPencilStep *step))completion
{
    if (!self.finished) {
        [self.delegate pencilStep:self didErase:YES];
        return;
    }

    _eraseCompletion = completion;

    double delayInSeconds = self.delay;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        if (self.type == MTPencilStepTypeDraw) {
            [self erase];
        }
        else if (self.type == MTPencilStepTypeMove) {
            self.finished = NO;
            [self.delegate pencilStep:self didErase:YES];
        }
    });
}

- (CGPathRef)immediatePathFromPoint:(CGPoint)point
{
    if (![self isEnoughValuesSetToDraw]) {
        return NULL;
    }

    self.startPoint = point;
    [self calculateMissingValues];

    if (self.type == MTPencilStepTypeDraw) {
        [self generatePath];
        return self.path;
    }
    else if (self.type == MTPencilStepTypeMove) {
        return NULL;
    }

    return NULL;
}

- (void)reset
{
    [self removeFromSuperlayer];
    self.finished = NO;
}




#pragma mark - Private

- (void)calculateMissingValues
{
    // end point
    if (_destinationType == MTPencilStepDestinationTypeRelative) {
        self.endPoint = CGPointMake(self.startPoint.x + self.distance, self.startPoint.y);
        self.endPoint = CGPointRotatedAroundPoint(self.endPoint, self.startPoint, self.angle);
    }

    self.distance = CGPointDistance(self.startPoint, self.endPoint);

    if (self.animationSpeed != NULL_NUMBER) {
        self.animationDuration = self.distance / self.animationSpeed;
    }
    else if (self.animationDuration == NULL_NUMBER) {
        self.animationDuration = 0.25;
    }
}

- (void)generatePath
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.startPoint.x, self.startPoint.y);

    // append provided path
    if (self.appendPath != NULL) {
        CGPathAddPath(path, NULL, self.appendPath);
    }

    // generate path from DSL
    else {
        // linear
        CGPathAddLineToPoint(path, NULL, self.endPoint.x, self.endPoint.y);
    }

    self.path = path;
}

- (void)draw
{
    _isErasing = NO;
    [self removeAllAnimations];

    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration          = self.animationDuration;
    pathAnimation.fromValue         = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue           = [NSNumber numberWithFloat:1.0f];
    pathAnimation.delegate          = self;
    [self addAnimation:pathAnimation forKey:@"drawing"];
}

- (void)erase
{
    _isErasing = YES;
    [self removeAllAnimations];

    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration          = self.animationDuration;
    pathAnimation.fromValue         = [NSNumber numberWithFloat:1.0f];
    pathAnimation.toValue           = [NSNumber numberWithFloat:0.0f];
    pathAnimation.delegate          = self;
    [self addAnimation:pathAnimation forKey:@"erasing"];
}

- (BOOL)isEnoughValuesSetToDraw
{
    BOOL hasEndPoint    = !CGPointEqualToPoint(self.endPoint, NULL_POINT);
    BOOL hasDistance    = self.distance != NULL_NUMBER;
    BOOL hasAngle       = self.angle != NULL_NUMBER;
    return hasEndPoint || (hasDistance && hasAngle);
}

- (void)ensureSaneDrawingAttributes
{
    if (!self.strokeColor) {
        self.strokeColor = [UIColor blackColor].CGColor;
    }

    if (self.lineWidth <= 0) {
        self.lineWidth = 1;
    }
}

@end
