//
//  MTRelativeExampleViewController.m
//  MTPencil
//
//  Created by Adam Kirk on 10/11/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MTRelativeExampleViewController.h"
#import "MTPencil.h"


@interface MTRelativeExampleViewController ()
@property (nonatomic, strong)          MTPencil *pencil;
@property (nonatomic, weak  ) IBOutlet UIButton *drawButton;
@property (nonatomic, weak  ) IBOutlet UIButton *reverseButton;
@end


@implementation MTRelativeExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.reverseButton.enabled = NO;

	_pencil = [MTPencil pencilWithView:self.view];

	[[[[_pencil move] to:CGPointMake(100, 200)] speed:300] width:1];
    [[_pencil draw] angle:-20 distance:100];
    [[_pencil draw] up:20];
    [[_pencil draw] right:50];
    [[_pencil draw] down:20];
    [[_pencil draw] left:20];
    [[_pencil draw] toEdge:UIRectEdgeRight];
    [[[_pencil draw] toEdge:UIRectEdgeBottom] inset:5];
    [[[_pencil draw] toEdge:UIRectEdgeLeft] inset:10];
    [[[_pencil draw] toEdge:UIRectEdgeTop] inset:10];
    [[_pencil draw] toEdge:UIRectEdgeRight];
}



#pragma mark - Actions

- (IBAction)drawButtonPressed:(UIButton *)sender
{
    self.drawButton.enabled     = NO;
    self.reverseButton.enabled  = NO;
    [_pencil erase];
	[_pencil drawWithCompletion:^(MTPencil *pencil) {
        self.drawButton.enabled     = YES;
        self.reverseButton.enabled  = YES;
    }];
}

- (IBAction)reverseButtonWasTapped:(id)sender
{
    self.drawButton.enabled     = NO;
    self.reverseButton.enabled  = NO;
    [_pencil eraseWithCompletion:^(MTPencil *pencil) {
        self.drawButton.enabled     = YES;
        self.reverseButton.enabled  = YES;
    }];
}


@end
