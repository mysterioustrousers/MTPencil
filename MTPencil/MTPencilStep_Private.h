//
//  MTPencilStep_Private.h
//  MTPencil
//
//  Created by Adam Kirk on 9/23/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MTPencilStep.h"
#import <MTGeometry.h>

typedef NS_ENUM(NSUInteger, MTPencilStepDestinationType) {
	MTPencilStepDestinationTypeAbsolute,
    MTPencilStepDestinationTypeRelative
};


@protocol MTPencilStepDelegate;


@interface MTPencilStep () {
    void (^_eraseCompletion)(MTPencilStep *step);
    MTPencilStepDestinationType _destinationType;
}
@property (nonatomic, weak) id<MTPencilStepDelegate>    delegate;
@property (nonatomic, assign) BOOL                        finished;
- (void)inheritFromStep:(MTPencilStep *)step;
- (void)startFromPoint:(CGPoint)point animated:(BOOL)animated;
- (CGPathRef)immediatePathFromPoint:(CGPoint)point;
- (void)reset;
@end


@protocol MTPencilStepDelegate <NSObject>
- (void)pencilStep:(MTPencilStep *)step didFinish:(BOOL)finished;
- (void)pencilStep:(MTPencilStep *)step didErase:(BOOL)finished;
@end
