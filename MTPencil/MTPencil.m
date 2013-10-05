//
//  MTShape.m
//  MTShapes
//
//  Created by Adam Kirk on 9/1/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "MTPencil.h"
#import "MTPencilStep.h"
#import "MTPencilStep_Private.h"


@interface MTPencil () <MTPencilStepDelegate>
@end


@implementation MTPencil {
    UIView  *_view;
    CGPoint _currentStartPoint;
    BOOL    _shouldAnimate;
}

- (id)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        _view               = view;
        _steps              = [NSMutableArray array];
        _completion         = nil;
        _eraseCompletion    = nil;
        _isDrawing          = NO;
        _isDrawn            = NO;
        _currentStartPoint  = CGPointZero;
        _shouldAnimate      = YES;
        _isCancelled        = NO;
        _isErased           = NO;
    }
    return self;
}




#pragma mark - Public

+ (MTPencil *)pencilWithView:(UIView *)view
{
	return [[MTPencil alloc] initWithView:view];
}

- (void)beginWithCompletion:(void (^)(MTPencil *pencil))completion
{
    _shouldAnimate    = YES;
    self.completion = completion;
    [self beginDrawing];
}

- (void)eraseWithCompletion:(void (^)(MTPencil *pencil))completion
{
    if (self.isDrawing || self.isErasing || !self.isDrawn) {
        if (completion) completion(self);
        return;
    }

    self.isDrawing          = NO;
    self.isErasing          = YES;
    self.eraseCompletion    = completion;
    self.isCancelled        = NO;
    _shouldAnimate          = YES;

    MTPencilStep *lastStep = [self.steps lastObject];
    if (lastStep) {
        [lastStep eraseWithCompletion:nil];
    }
}

- (CGPathRef)fullPath
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint point = CGPointZero;
    for (MTPencilStep *step in self.steps) {
        CGPathRef p = [step immediatePathFromPoint:point];
        if (p != NULL) {
            CGPathAddPath(path, NULL, p);
            point = step.endPoint;
        }
        else if (!CGPointEqualToPoint(step.endPoint, NULL_POINT)) {
            CGPathMoveToPoint(path, NULL, step.endPoint.x, step.endPoint.y);
            point = step.endPoint;
        }
    }

    return path;
}

- (void)erase
{
    for (MTPencilStep *step in self.steps) {
        [step removeFromSuperlayer];
    }
    self.isDrawn        = NO;
    self.isErased       = YES;
    self.isCancelled    = NO;
}

- (void)reset
{
    [self erase];
    [self.steps removeAllObjects];
    self.completion         = nil;
    self.eraseCompletion    = nil;
    self.isDrawing          = NO;
    self.isDrawn            = NO;
    _currentStartPoint      = CGPointZero;
    _shouldAnimate          = YES;
    self.isCancelled        = NO;
    self.isErased           = NO;

}

- (void)cancel
{
    self.isCancelled = YES;
}

- (void)complete
{
    _shouldAnimate = NO;
    self.completion = nil;
    [self beginDrawing];
}

- (void)setDrawsAsynchronously:(BOOL)drawsAsynchronously
{
    _drawsAsynchronously = drawsAsynchronously;
    for (MTPencilStep *step in self.steps) {
        step.drawsAsynchronously = _drawsAsynchronously;
    }
}



#pragma mark (add steps)

- (MTPencilStep *)move
{
    MTPencilStep *step          = [MTPencilStep new];
    step.type                   = MTPencilStepTypeMove;
    step.delegate               = self;
    step.frame                  = _view.bounds;
    step.bounds                 = _view.bounds;
    step.drawsAsynchronously    = _drawsAsynchronously;
    [self.steps addObject:step];
    return step;
}

- (MTPencilStep *)draw
{
    MTPencilStep *step          = [MTPencilStep new];
    step.type                   = MTPencilStepTypeDraw;
    step.delegate               = self;
    step.frame                  = _view.bounds;
    step.bounds                 = _view.bounds;
    step.drawsAsynchronously    = _drawsAsynchronously;
    [self.steps addObject:step];
    return step;
}




#pragma mark - DELEGATE pencil step

- (void)pencilStep:(MTPencilStep *)finishedStep didFinish:(BOOL)finished
{
    _currentStartPoint = finishedStep.endPoint;

    if (self.isCancelled) {
        return;
    }

    for (MTPencilStep *step in self.steps) {
        if (!step.finished) {
            [_view.layer addSublayer:step];
            [step inheritFromStep:finishedStep];
            [step startFromPoint:_currentStartPoint animated:_shouldAnimate];
            return;
        }
    }
    self.isDrawing  = NO;
    self.isDrawn    = YES;
    self.isErasing  = NO;
    self.isErased   = NO;
    if (self.completion) self.completion(self);
}

- (void)pencilStep:(MTPencilStep *)erasedStep didErase:(BOOL)finished
{
    [erasedStep removeFromSuperlayer];

    if (self.isCancelled) {
        return;
    }

    for (MTPencilStep *step in [self.steps reverseObjectEnumerator]) {
        if (step.finished) {
            [step eraseWithCompletion:nil];
            return;
        }
    }
    self.isDrawing  = NO;
    self.isDrawn    = NO;
    self.isErasing  = NO;
    self.isErased   = YES;
    if (self.eraseCompletion) self.eraseCompletion(self);
}




#pragma mark - Private

- (void)beginDrawing
{
    if (self.isDrawing || self.isErasing || self.isDrawn || self.isCancelled) {
        if (self.completion) self.completion(self);
        return;
    }

    self.isDrawing      = YES;
    self.isErasing      = NO;
    self.isCancelled    = NO;
    self.isErased       = NO;

    for (MTPencilStep *step in self.steps) {
        [step reset];
    }

    if ([self.steps count] > 0) {
        MTPencilStep *firstStep = self.steps[0];
        [_view.layer addSublayer:firstStep];
        [firstStep startFromPoint:CGPointZero animated:_shouldAnimate];
    }
}

@end
