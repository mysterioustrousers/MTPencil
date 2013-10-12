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


@interface MTPencilStep ()
@property (nonatomic, assign, readwrite) MTPencilStepType            type;
@property (nonatomic, assign, readwrite) MTPencilStepState           state;
@property (nonatomic, weak             ) id<MTPencilStepDelegate>    delegate;
@property (nonatomic, assign           ) MTPencilStepDestinationType destinationType;
@property (nonatomic, assign, readwrite) CGFloat                     length;
- (void)inheritFromStep:(MTPencilStep *)step;
@end


@protocol MTPencilStepDelegate <NSObject>
- (void)pencilStep:(MTPencilStep *)step didFinish:(BOOL)finished;
- (void)pencilStep:(MTPencilStep *)step didErase:(BOOL)erased;
- (CGFloat)pencilStep:(MTPencilStep *)step valueForEdge:(UIRectEdge)edge;
@end
