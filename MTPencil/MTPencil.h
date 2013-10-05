//
//  MTShape.h
//  MTShapes
//
//  Created by Adam Kirk on 9/1/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "MTPencilStep.h"


@interface MTPencil : NSObject

@property (nonatomic, strong) NSMutableArray *steps;
@property (nonatomic, assign) BOOL           drawsAsynchronously;
@property (nonatomic, copy) void           (^completion)(MTPencil *pencil);
@property (nonatomic, copy) void           (^eraseCompletion)(MTPencil *pencil);
@property (nonatomic, assign) BOOL           isDrawing;
@property (nonatomic, assign) BOOL           isDrawn;
@property (nonatomic, assign) BOOL           isErasing;
@property (nonatomic, assign) BOOL           isErased;
@property (nonatomic, assign) BOOL           isCancelled;


+ (MTPencil *)pencilWithView:(UIView *)view;

- (void)beginWithCompletion:(void (^)(MTPencil *pencil))completion;

- (void)eraseWithCompletion:(void (^)(MTPencil *pencil))completion;

- (CGPathRef)fullPath;

- (void)erase;

- (void)reset;

- (void)cancel;

- (void)complete;


#pragma mark - Add Steps

- (MTPencilStep *)move;

- (MTPencilStep *)draw;


@end
