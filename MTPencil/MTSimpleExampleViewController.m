//
//  MTViewController.m
//  MTShapes
//
//  Created by Adam Kirk on 9/1/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "MTSimpleExampleViewController.h"
#import "MTPencil.h"


@interface MTSimpleExampleViewController ()
@property (nonatomic, strong)          MTPencil *pencil;
@property (nonatomic, weak  ) IBOutlet UIButton *drawButton;
@property (nonatomic, weak  ) IBOutlet UIButton *reverseButton;
@end


@implementation MTSimpleExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.reverseButton.enabled = NO;

    MTPencilStepSpeed speed = 100;

	_pencil = [MTPencil pencilWithView:self.view];

    [[_pencil config] strokeColor:[UIColor darkGrayColor]];
	[[_pencil move] to:CGPointMake(100, 200)];
	[[[_pencil draw] angle:MTPencilStepAngleUpRight distance:20]    speed:speed];
	[[[_pencil draw] angle:MTPencilStepAngleUp      distance:50]    speed:speed];
	[[[_pencil draw] angle:MTPencilStepAngleRight   distance:100]	speed:speed];
	[[[_pencil draw] angle:MTPencilStepAngleDown    distance:200]	speed:speed];
	[[[_pencil draw] angle:MTPencilStepAngleLeft	distance:100]	speed:speed];
	[[[_pencil draw] angle:MTPencilStepAngleUp      distance:123]	speed:speed];
	[[[_pencil draw] angle:MTPencilStepAngleUpLeft  distance:20]    speed:speed];

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
