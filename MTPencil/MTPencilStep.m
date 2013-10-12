//
//  MTPencilDrawingStep.m
//  MTPencil
//
//  Created by Adam Kirk on 9/23/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MTPencilStep.h"
#import "MTPencilStep_Private.h"
@import CoreText;


@interface MTPencilStep ()
@property (nonatomic, copy  ) NSString  *string;
@property (nonatomic, strong) UIFont    *font;
@end


@implementation MTPencilStep

- (id)init
{
    self = [super init];
    if (self) {
        _type                   = MTPencilStepTypeMove;

        // absolute destination defaults
        _startPoint             = NULL_POINT;
        _endPoint               = NULL_POINT;

        // relative destination defaults
        _angle                  = NULL_NUMBER;
        _distance               = 0;
        _toEdge                 = UIRectEdgeNone;
        _inset                  = 0;

        // paths
        _appendPath             = NULL;

        // attributes
        _animationSpeed         = NULL_NUMBER;
        _animationDuration      = NULL_NUMBER;
        _delay                  = 0;
        _easingFunction         = kMTPencilEaseLinear;

        // private
        _destinationType        = MTPencilStepDestinationTypeAbsolute;
        _state                  = MTPencilStepStateNotStarted;
        _length                 = 0;

        // callbacks
        _completion             = nil;
        _eraseCompletion        = nil;

        // appearance
        self.fillColor          = [UIColor clearColor].CGColor;
        self.strokeColor        = [UIColor blackColor].CGColor;
        self.lineWidth          = 1;
    }
    return self;
}

- (void)dealloc
{
    if (self.appendPath != NULL) {
        CFRelease(self.appendPath);
    }
    for (NSString *animationKey in self.animationKeys) {
        CAAnimation *animation = [self animationForKey:animationKey];
        animation.delegate = nil;
    }
}





#pragma mark - Public

#pragma mark (Controlling Playback)

- (void)drawWithCompletion:(void (^)(MTPencilStep *))completion
{
    if (self.state != MTPencilStepStateNotStarted) {
        return;
    }

    self.completion = completion;

    double delayInSeconds = self.delay;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        if (self.type == MTPencilStepTypeDraw) {
            [self generatePath];
            [self addDrawingAnimation];
        }
        else if (self.type == MTPencilStepTypeMove) {
            self.state = MTPencilStepStateDrawn;
            [self.delegate pencilStep:self didFinish:YES];
        }
    });
}

- (void)eraseWithCompletion:(void (^)(MTPencilStep *step))completion
{
    if (self.state != MTPencilStepStateDrawn) {
        return;
    }

    self.eraseCompletion = completion;

    double delayInSeconds = self.delay;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        if (self.type == MTPencilStepTypeDraw) {
            [self addErasingAnimation];
        }
        else if (self.type == MTPencilStepTypeMove) {
            self.state = MTPencilStepStateNotStarted;
            [self.delegate pencilStep:self didErase:YES];
        }
    });
}

- (void)scrub:(CGFloat)percent
{
    if (!self.path) {
        [self finish];
    }
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.strokeEnd = percent;
    [CATransaction commit];
}

- (void)finish
{
    [self removeAllAnimations];
    [self generatePath];

}

- (void)erase
{
    [self removeAllAnimations];
    [self removeFromSuperlayer];
    self.length = 0;
    self.path   = nil;
    self.state  = MTPencilStepStateNotStarted;
}


#pragma mark (Destination)

- (MTPencilStep *)to:(CGPoint)point
{
    self.destinationType    = MTPencilStepDestinationTypeAbsolute;
    self.endPoint           = point;
    self.angle              = NULL_NUMBER;
    self.distance           = 0;
    return self;
}

- (MTPencilStep *)angle:(CGFloat)angle distance:(CGFloat)distance
{
    NSAssert(distance > 0, @"distance must be a positive value greater than 0");
    self.destinationType    = MTPencilStepDestinationTypeRelative;
    self.angle              = angle;
    self.distance           = distance;
    self.endPoint           = NULL_POINT;
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
    NSAssert(edge != UIRectEdgeNone && edge != UIRectEdgeAll, @"You must specify a distinct edge.");
    self.destinationType    = MTPencilStepDestinationTypeRelative;
    self.toEdge             = edge;
    return self;
}

- (MTPencilStep *)inset:(CGFloat)inset
{
    self.inset = inset;
    return self;
}


#pragma mark (Adding Paths)

- (MTPencilStep *)path:(CGPathRef)path
{
    assert(path != NULL);
    CFRetain(path);
    self.appendPath = path;
    return self;
}


#pragma mark (Adding Strings)

- (MTPencilStep *)string:(NSString *)string
{
    self.string = string;
    return self;
}

- (MTPencilStep *)attributedString:(NSAttributedString *)attributedString
{
    self.attributedString = attributedString;
    return self;
}


#pragma mark (Speed)

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

- (MTPencilStep *)easingFunction:(MTPencilEasingFunction)easingFunction
{
    self.easingFunction = easingFunction;
    return self;
}


#pragma mark (Appearance)

- (MTPencilStep *)strokeColor:(UIColor *)color
{
    self.strokeColor = color.CGColor;
    return self;
}

- (MTPencilStep *)width:(CGFloat)width
{
    self.lineWidth = width;
    return self;
}

- (MTPencilStep *)font:(UIFont *)font
{
    self.font = font;
    return self;
}



#pragma mark (Misc)

- (MTPencilStep *)delay:(NSTimeInterval)delay
{
    self.delay = delay;
    return self;
}


#pragma mark (Getting Generated Paths)

- (CGPathRef)CGPath
{
    if (self.type == MTPencilStepTypeDraw) {
        [self generatePath];
        return self.path;
    }
    else if (self.type == MTPencilStepTypeMove) {
        return NULL;
    }

    return NULL;
}

#pragma mark (Properties)

static CGPoint measuringLengthCurrentStartPoint;
static CGFloat measuringLengthCurrentLength;

- (CGFloat)length
{
    if (!self.path) {
        [self generatePath];
    }

    if (_length == 0) {
        measuringLengthCurrentStartPoint    = self.startPoint;
        measuringLengthCurrentLength        = 0;
        CGPathApply(self.path, nil, pathApplyLengthFunction);
        _length = measuringLengthCurrentLength;
    }

    return _length;
}

- (UIFont *)font
{
    if (!_font) {
        _font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    }
    return _font;
}




#pragma mark - DELEGATE CAAnimation

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (self.state == MTPencilStepStateDrawing) {
        self.state = MTPencilStepStateDrawn;
        if (self.completion) self.completion(self);
        [self.delegate pencilStep:self didFinish:YES];
    }
    else if (self.state == MTPencilStepStateErasing){
        [self removeFromSuperlayer];
        self.state = MTPencilStepStateNotStarted;
        self.length = 0;
        if (self.eraseCompletion) self.eraseCompletion(self);
        [self.delegate pencilStep:self didErase:YES];
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

    if (self.easingFunction == kMTPencilEaseLinear) {
        self.easingFunction = step.easingFunction;
    }
}






#pragma mark - Private

- (void)calculateDuration
{
    if (self.animationSpeed != NULL_NUMBER && self.length > 0) {
        self.animationDuration = self.length / self.animationSpeed;
    }
    else if (self.animationDuration == NULL_NUMBER) {
        self.animationDuration = 0.25;
    }
}

- (void)generatePath
{
    // get endpoint from string path
    CGPathRef stringPath = NULL;
    if (self.attributedString || self.string) {
        if (!self.attributedString) {
            self.attributedString = [[NSAttributedString alloc] initWithString:self.string
                                                                    attributes:@{ NSFontAttributeName: self.font }];
        }
        CGPathRef path = [self pathOfAttributedString:self.attributedString];

        // flip path vertically
        CGFloat height = CGPathGetPathBoundingBox(path).size.height;
        CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, height);
        CGPathRef flippedPath = CGPathCreateCopyByTransformingPath(path, &flipVertical);
        CGAffineTransform translateToStartPoint = CGAffineTransformMakeTranslation(self.startPoint.x, self.startPoint.y);
        stringPath = CGPathCreateCopyByTransformingPath(flippedPath, &translateToStartPoint);
        CFRelease(flippedPath);

        self.endPoint = CGPathGetCurrentPoint(self.appendPath);
    }

    // get endpoint of appending path
    else if (self.appendPath != NULL) {
        self.endPoint = CGPathGetCurrentPoint(self.appendPath);
    }

    // figure endpoint from an edge
    else if (self.toEdge != UIRectEdgeNone) {
        if (self.toEdge == UIRectEdgeTop) {
            CGFloat minY    = [self.delegate pencilStep:self valueForEdge:UIRectEdgeTop];
            self.endPoint   = CGPointMake(self.startPoint.x, minY + self.inset);
        }
        else if (self.toEdge == UIRectEdgeLeft) {
            CGFloat minX    = [self.delegate pencilStep:self valueForEdge:UIRectEdgeLeft];
            self.endPoint   = CGPointMake(minX + self.inset, self.startPoint.y);
        }
        else if (self.toEdge == UIRectEdgeBottom) {
            CGFloat maxY    = [self.delegate pencilStep:self valueForEdge:UIRectEdgeBottom];
            self.endPoint   = CGPointMake(self.startPoint.x, maxY - self.inset);
        }
        else if (self.toEdge == UIRectEdgeRight) {
            CGFloat maxX    = [self.delegate pencilStep:self valueForEdge:UIRectEdgeRight];
            self.endPoint   = CGPointMake(maxX - self.inset, self.startPoint.y);
        }
    }

    // figure endpoint from distance and angle
    else if (self.distance > 0) {
        CGPoint endPoint;
        endPoint.y      = self.startPoint.y;
        endPoint.x      = self.startPoint.x + self.distance;
        endPoint        = CGPointRotatedAroundPoint(endPoint, self.startPoint, self.angle);
        self.endPoint   = endPoint;
    }

    // get endpoint from angle and distance
    else {
        if (self.destinationType == MTPencilStepDestinationTypeRelative) {
            self.endPoint = CGPointMake(self.startPoint.x + self.distance, self.startPoint.y);
            self.endPoint = CGPointRotatedAroundPoint(self.endPoint, self.startPoint, self.angle);
        }
    }

    [self assertHasEnoughInfoToDraw];

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.startPoint.x, self.startPoint.y);

    if (self.type == MTPencilStepTypeMove) {
        CGPathMoveToPoint(path, NULL, self.endPoint.x, self.endPoint.y);
    }
    else if (self.type == MTPencilStepTypeDraw) {
        // append string path
        if (stringPath != NULL && !CGPathIsEmpty(stringPath)) {
            CGPathAddPath(path, NULL, stringPath);
        }

        // append path
        else if (self.appendPath != NULL) {
            CGPathAddPath(path, NULL, self.appendPath);
        }

        // add path generated from DSL
        else {
            CGPathAddLineToPoint(path, NULL, self.endPoint.x, self.endPoint.y);
        }
    }

    self.path = path;

    if (stringPath != NULL) {
        CFRelease(stringPath);
    }
}

- (void)addDrawingAnimation
{
    [self calculateDuration];
    self.state = MTPencilStepStateDrawing;
    CAKeyframeAnimation *keyframeAnimation  = [CAKeyframeAnimation new];
    keyframeAnimation.keyPath               = @"strokeEnd";
    keyframeAnimation.duration              = self.animationDuration;
    keyframeAnimation.delegate              = self;
    keyframeAnimation.values                = [self floatValuesWithDuration:self.animationDuration
                                                                   function:self.easingFunction
                                                                       from:0.0
                                                                         to:1.0];
    [self addAnimation:keyframeAnimation forKey:@"drawing"];
}

- (void)addErasingAnimation
{
    self.state = MTPencilStepStateErasing;
    [self removeAllAnimations];
    CAKeyframeAnimation *keyframeAnimation  = [CAKeyframeAnimation new];
    keyframeAnimation.keyPath               = @"strokeEnd";
    keyframeAnimation.duration              = self.animationDuration;
    keyframeAnimation.delegate              = self;
    NSArray *values                         = [self floatValuesWithDuration:self.animationDuration
                                                                   function:self.easingFunction
                                                                       from:0.0
                                                                         to:1.0] ;

    NSMutableArray *reversedArray = [NSMutableArray new];
    for (id element in [values reverseObjectEnumerator]) {
        [reversedArray addObject:element];
    }

    keyframeAnimation.values = reversedArray;
    [self addAnimation:keyframeAnimation forKey:@"drawing"];
}

- (void)assertHasEnoughInfoToDraw
{
    BOOL hasStartPoint      = !CGPointEqualToPoint(self.startPoint, NULL_POINT);

    BOOL hasEndPoint        = !CGPointEqualToPoint(self.endPoint, NULL_POINT);
    BOOL hasDistance        = self.distance != NULL_NUMBER;
    BOOL hasAngle           = self.angle != NULL_NUMBER;
    BOOL hasSufficientEnd   = hasEndPoint || (hasDistance && hasAngle);

    NSAssert(hasStartPoint, @"A step cannot be drawn unless its startPoint is set");
    NSAssert(hasSufficientEnd, (@"A step cannot be drawn unless an endpoint is set or both angle and distance are set"));
}


#pragma mark (Calculating Path Length)

void pathApplyLengthFunction(void *length, const CGPathElement *element)
{
    if (element->type == kCGPathElementAddLineToPoint || element->type == kCGPathElementCloseSubpath) {
        CGPoint endPoint                    = element->points[0];
        measuringLengthCurrentLength       += CGPointDistance(measuringLengthCurrentStartPoint, endPoint);
        measuringLengthCurrentStartPoint    = endPoint;
    }
    else if (element->type == kCGPathElementAddQuadCurveToPoint) {
        CGPoint controlPoint                = element->points[0];
        CGPoint endPoint                    = element->points[1];
        measuringLengthCurrentLength       += quadCurveToPointLength(measuringLengthCurrentStartPoint, endPoint, controlPoint);
        measuringLengthCurrentStartPoint    = endPoint;
    }
    else if (element->type == kCGPathElementAddCurveToPoint) {
        CGPoint controlPoint1               = element->points[0];
        CGPoint controlPoint2               = element->points[1];
        CGPoint endPoint                    = element->points[2];
        measuringLengthCurrentLength       += curveToPointLength(measuringLengthCurrentStartPoint, endPoint, controlPoint1, controlPoint2);
        measuringLengthCurrentStartPoint    = endPoint;
    }
}

/**
 * From Bartosz Ciechanowski
 * http://stackoverflow.com/questions/12024674/get-cgpath-total-length
 */
float quadCurveToPointLength(CGPoint startPoint, CGPoint endPoint, CGPoint controlPoint)
{
    const int kSubdivisions = 100;
    const float step        = 1.0f / (float)kSubdivisions;
    float totalLength       = 0.0f;
    CGPoint prevPoint       = startPoint;

    // starting from i = 1, since for i = 0 calulated point is equal to start point
    for (int i = 1; i <= kSubdivisions; i++) {
        float t             = i * step;
        float x             = (1.0 - t) * (1.0 - t) * startPoint.x + 2.0 * (1.0 - t) * t * controlPoint.x + t * t * endPoint.x;
        float y             = (1.0 - t) * (1.0 - t) * startPoint.y + 2.0 * (1.0 - t) * t * controlPoint.y + t * t * endPoint.y;
        CGPoint newPoint    = CGPointMake(x, y);
        totalLength        += CGPointDistance(newPoint, prevPoint);
        prevPoint           = newPoint;
    }
    
    return totalLength;
}


float curveToPointLength(CGPoint startPoint, CGPoint endPoint, CGPoint controlPoint1, CGPoint controlPoint2)
{
    const int kSubdivisions = 100;
    const float step        = 1.0f / (float)kSubdivisions;
    float totalLength       = 0.0f;
    CGPoint prevPoint       = startPoint;

    // starting from i = 1, since for i = 0 calulated point is equal to start point
    for (CGFloat t = 0.0; t <= 1.00001; t += step) {
        float x             = bezierInterpolation(t, startPoint.x, controlPoint1.x, controlPoint2.x, endPoint.x);
        float y             = bezierInterpolation(t, startPoint.y, controlPoint1.y, controlPoint2.y, endPoint.y);
        CGPoint newPoint    = CGPointMake(x, y);
        totalLength        += CGPointDistance(newPoint, prevPoint);
        prevPoint           = newPoint;
    }
    
    return totalLength;
}

/**
 * http://stackoverflow.com/questions/4058979/find-a-point-a-given-distance-along-a-simple-cubic-bezier-curve-on-an-iphone/4060392#4060392
 */
CGFloat bezierInterpolation(CGFloat t, CGFloat a, CGFloat b, CGFloat c, CGFloat d) {
    CGFloat t2 = t * t;
    CGFloat t3 = t2 * t;
    return a + (-a * 3 + t * (3 * a - a * t)) * t
    + (3 * b + t * (-6 * b + b * 3 * t)) * t
    + (c * 3 - c * 3 * t) * t2
    + d * t3;
}


#pragma mark (String Paths)

- (CGPathRef)pathOfAttributedString:(NSAttributedString *)attributedString
{
    CGMutablePathRef path = CGPathCreateMutable();

    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedString);

    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter,
                                                                        CFRangeMake(0, 0),
                                                                        NULL,
                                                                        CGSizeMake(NSIntegerMax, NSIntegerMax),
                                                                        NULL);

    CGPathRef framePath = CGPathCreateWithRect(CGRectMake(0, 0, suggestedSize.width, suggestedSize.height), NULL);

    CTFrameRef frame = CTFramesetterCreateFrame(framesetter,
                                                CFRangeMake(0, 0),
                                                framePath,
                                                NULL);

    CFArrayRef lines    = CTFrameGetLines(frame);
    CFIndex lineCount   = CFArrayGetCount(lines);
    if (lineCount > 0) {
        CGPoint lineOrigins[lineCount];
        CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), lineOrigins);
        for (NSInteger i = 0; i < lineCount; i++) {
            CTLineRef line  = CFArrayGetValueAtIndex(lines, i);
            CFArrayRef runs = CTLineGetGlyphRuns(line);
            CFIndex runCount = CFArrayGetCount(runs);
            for (NSInteger j = 0; j < runCount; j++) {
                CTRunRef run                = CFArrayGetValueAtIndex(runs, j);
                NSUInteger glyphCount       = CTRunGetGlyphCount(run);
                if (glyphCount > 0) {
                    CGPoint positions[glyphCount];
                    CGGlyph glyphs[glyphCount];
                    CTRunGetPositions(run, CFRangeMake(0, 0), positions);
                    CTRunGetGlyphs(run, CFRangeMake(0, 0), glyphs);
                    for (NSInteger k = 0; k < glyphCount; k++) {
                        CGPoint lineOrigin      = lineOrigins[i];
                        CGPoint glyphPosition   = positions[k];
                        CGPoint glyphPoint      = CGPointMake(lineOrigin.x + glyphPosition.x,
                                                              lineOrigin.y + glyphPosition.y);
                        CGPathMoveToPoint(path, NULL, glyphPoint.x, glyphPoint.y);

                        CGGlyph glyph                       = glyphs[k];
                        CTFontRef font                      = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
                        CGPathRef glyphPath                 = CTFontCreatePathForGlyph(font, glyph, NULL);
                        const CGAffineTransform translate   = CGAffineTransformMakeTranslation(glyphPoint.x, glyphPoint.y);
                        CGPathAddPath(path, &translate, glyphPath);

                        CFRelease(glyphPath);
                    }
                }
            }
        }
    }

    CFRelease(framesetter);
    CFRelease(framePath);
    CFRelease(frame);
    CFAutorelease(path);

    return path;
}


#pragma mark (Easing Interpolation)

static const NSInteger fps      = 60;
static const NSInteger second   = 1000;

- (NSArray *)floatValuesWithDuration:(NSTimeInterval)duration
                            function:(MTPencilEasingFunction)timingFuction
                                from:(CGFloat)fromFloat
                                  to:(CGFloat)toFloat
{
    NSInteger steps         = (NSInteger)ceil(fps * duration) + 2;
	NSMutableArray *values  = [NSMutableArray arrayWithCapacity:steps];
    CGFloat increment       = 1.0 / (steps - 1);
    CGFloat progress        = 0.0;
    duration                *= second;

    for (NSInteger i = 0; i < steps; i++) {
        CGFloat v           = timingFuction(duration * progress, 0, 1, duration, 1.70158);

        CGFloat flowt       = 0;
        flowt               = fromFloat + (v * (toFloat - fromFloat));

        [values addObject:@(flowt)];

        progress += increment;
    }
    
    return values;
}

@end
