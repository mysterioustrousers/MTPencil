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
@property (nonatomic, assign           ) MTPencilState pausedState;
@property (nonatomic, assign, readwrite) MTPencilState state;
@end


@implementation MTPencil

- (id)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        _view               = view;
        _steps              = [NSMutableArray array];
        _completion         = nil;
        _eraseCompletion    = nil;
        _state              = MTPencilStateNotStarted;
    }
    return self;
}

- (void)dealloc
{
    for (MTPencilStep *step in [self actionSteps]) {
        [step removeFromSuperlayer];
    }
}




#pragma mark - Public

#pragma mark (create pencil)

+ (MTPencil *)pencilWithView:(UIView *)view
{
	return [[MTPencil alloc] initWithView:view];
}

#pragma mark (Adding Drawing Steps)

- (MTPencilStep *)config
{
    MTPencilStep *step          = [MTPencilStep new];
    step.type                   = MTPencilStepTypeConfig;
    step.delegate               = self;
    [self.steps addObject:step];
    return step;
}

- (MTPencilStep *)move
{
    MTPencilStep *step          = [MTPencilStep new];
    step.type                   = MTPencilStepTypeMove;
    step.delegate               = self;
    step.frame                  = self.view.bounds;
    step.bounds                 = self.view.bounds;
    step.drawsAsynchronously    = self.drawsAsynchronously;
    [self.steps addObject:step];
    return step;
}

- (MTPencilStep *)draw
{
    MTPencilStep *step          = [MTPencilStep new];
    step.type                   = MTPencilStepTypeDraw;
    step.delegate               = self;
    step.frame                  = self.view.bounds;
    step.bounds                 = self.view.bounds;
    step.drawsAsynchronously    = self.drawsAsynchronously;
    [self.steps addObject:step];
    return step;
}

#pragma mark (Controlling Playback)

- (void)drawWithCompletion:(void (^)(MTPencil *pencil))completion
{
    if (self.state != MTPencilStepStateNotStarted) {
        return;
    }

    self.completion = completion;

    [self erase];
    self.state = MTPencilStateDrawing;

    if ([self.steps count] > 0) {
        MTPencilStep *firstStep = self.steps[0];
        if (firstStep.type == MTPencilStepTypeConfig) {
            firstStep.endPoint = CGPointZero;
        }
        else {
            [self.view.layer addSublayer:firstStep];
        }
        firstStep.startPoint = CGPointZero;
        [firstStep drawWithCompletion:firstStep.completion];
    }
}

- (void)eraseWithCompletion:(void (^)(MTPencil *pencil))completion
{
    if (self.state != MTPencilStateDrawn) {
        if (completion) completion(self);
        return;
    }

    self.state              = MTPencilStateErasing;
    self.eraseCompletion    = completion;

    MTPencilStep *lastStep = [[self actionSteps] lastObject];
    if (lastStep) {
        [lastStep eraseWithCompletion:lastStep.eraseCompletion];
    }
}

- (void)scrub:(CGFloat)percent
{
    for (MTPencilStep *step in [self actionSteps]) {
        if (!step.path) {
            [self finish];
        }
        [step scrub:0];
    }

    CGFloat totalLength = 0;
    for (MTPencilStep *step in [self actionSteps]) {
        totalLength += step.length;
    }

    CGFloat scrubLength = totalLength * percent;

    for (MTPencilStep *step in [self actionSteps]) {
        scrubLength -= step.length;
        if (scrubLength > 0) {
            [step scrub:1.0];
        }
        else {
            CGFloat stepScrubLength = step.length - fabs(scrubLength);
            CGFloat scrubPercent = stepScrubLength / step.length;
            [step scrub:scrubPercent];
            return;
        }
    }
}

- (void)finish
{
    MTPencilStep *previousStep = nil;
    for (MTPencilStep *step in self.steps) {
        if (previousStep) {
            [step inheritFromStep:previousStep];
        }
        if (step.type != MTPencilStepTypeConfig) {
            if (CGPointEqualToPoint(step.startPoint, NULL_POINT)) {
                if (previousStep && previousStep.type != MTPencilStepTypeConfig) {
                    step.startPoint = previousStep.endPoint;
                }
                else {
                    step.startPoint = CGPointZero;
                }
            }
            [step finish];
            [self.view.layer addSublayer:step];
        }
        previousStep = step;
    }
    self.state = MTPencilStepStateDrawn;
    if (self.completion) self.completion(self);
}

- (void)erase
{
    for (MTPencilStep *step in [self actionSteps]) {
        [step erase];
    }
    self.state = MTPencilStateNotStarted;
}

- (void)reset
{
    [self erase];
    [self.steps removeAllObjects];
    self.completion = nil;
    self.eraseCompletion = nil;
}



#pragma mark (Getting Generated Paths)

- (CGPathRef)CGPath
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint point = CGPointZero;
    for (MTPencilStep *step in [self actionSteps]) {
        step.startPoint = point;
        CGPathRef p = [step CGPath];
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

#pragma mark (Properties)

- (void)setDrawsAsynchronously:(BOOL)drawsAsynchronously
{
    _drawsAsynchronously = drawsAsynchronously;
    for (MTPencilStep *step in self.steps) {
        step.drawsAsynchronously = _drawsAsynchronously;
    }
}





#pragma mark - DELEGATE pencil step

- (void)pencilStep:(MTPencilStep *)finishedStep didFinish:(BOOL)finished
{
    for (MTPencilStep *step in self.steps) {
        if (step.state == MTPencilStepStateNotStarted) {
            [step inheritFromStep:finishedStep];
            if (step.type == MTPencilStepTypeConfig) {
                step.startPoint = step.endPoint = finishedStep.endPoint;
                step.state      = MTPencilStepStateDrawn;
                finishedStep    = step;
                continue;
            }
            step.hidden = YES;
            [self.view.layer addSublayer:step];
            step.startPoint = finishedStep.endPoint;
            [step drawWithCompletion:step.completion];
            return;
        }
    }
    self.state = MTPencilStateDrawn;
    if (self.completion) self.completion(self);
}

- (void)pencilStep:(MTPencilStep *)erasedStep didErase:(BOOL)erased
{
    [erasedStep removeFromSuperlayer];

    for (MTPencilStep *step in [[self actionSteps] reverseObjectEnumerator]) {
        if (step.state == MTPencilStepStateDrawn) {
            [step eraseWithCompletion:step.eraseCompletion];
            return;
        }
    }
    self.state = MTPencilStateNotStarted;
    if (self.eraseCompletion) self.eraseCompletion(self);
}




#pragma mark - Private

- (CGFloat)pencilStep:(MTPencilStep *)step valueForEdge:(UIRectEdge)edge
{
    if (edge == UIRectEdgeTop) {
        return CGRectGetMinY(self.view.bounds);
    }
    else if (edge == UIRectEdgeLeft) {
        return CGRectGetMinX(self.view.bounds);
    }
    else if (edge == UIRectEdgeBottom) {
        return CGRectGetMaxY(self.view.bounds);
    }
    else if (edge == UIRectEdgeRight) {
        return CGRectGetMaxX(self.view.bounds);
    }
    return 0;
}

- (NSArray *)actionSteps
{
    return [self.steps filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(MTPencilStep *step, NSDictionary *bindings) {
        return step.type != MTPencilStepTypeConfig;
    }]];
}


@end
