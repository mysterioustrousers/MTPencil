//
//  MTShape.h
//  MTShapes
//
//  Created by Adam Kirk on 9/1/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "MTPencilStep.h"


typedef NS_ENUM(NSUInteger, MTPencilState) {
    MTPencilStateNotStarted,
    MTPencilStateDrawing,
    MTPencilStateDrawn,
    MTPencilStateErasing
};


@interface MTPencil : NSObject

@property (nonatomic, strong, readonly) UIView         *view;
@property (nonatomic, strong, readonly) NSMutableArray *steps;
@property (nonatomic, assign, readonly) MTPencilState  state;
@property (nonatomic, assign          ) BOOL           drawsAsynchronously;
@property (nonatomic, copy            ) void           (^completion)(MTPencil *pencil);
@property (nonatomic, copy            ) void           (^eraseCompletion)(MTPencil *pencil);


///------------------------------
/// Creating a pencil
///------------------------------

+ (MTPencil *)pencilWithView:(UIView *)view;


///------------------------------
/// Adding Drawing Steps
///------------------------------

- (MTPencilStep *)move;

- (MTPencilStep *)draw;


///------------------------------
/// Controlling Playback
///------------------------------

- (void)beginWithCompletion:(void (^)(MTPencil *pencil))completion;

- (void)eraseWithCompletion:(void (^)(MTPencil *pencil))completion;

- (void)scrub:(CGFloat)percent;

- (void)finish;

- (void)erase;

- (void)reset;


///------------------------------
/// Getting Generated Paths
///------------------------------

- (CGPathRef)CGPath;



@end
