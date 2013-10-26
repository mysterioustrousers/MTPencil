//
//  MTTextExampleViewController.m
//  MTPencil
//
//  Created by Adam Kirk on 10/10/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MTTextExampleViewController.h"
#import "MTPencil.h"


@interface MTTextExampleViewController ()
@property (nonatomic, strong)          MTPencil *pencil;
@property (nonatomic, weak  ) IBOutlet UIButton *drawButton;
@property (nonatomic, weak  ) IBOutlet UIButton *reverseButton;
@end


@implementation MTTextExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.reverseButton.enabled = NO;

	_pencil = [MTPencil pencilWithView:self.view];
    [[_pencil move] to:CGPointMake(10, 100)];
    [[[[_pencil draw] string:@"Mysterious\nTrousers"] font:[UIFont systemFontOfSize:60]] duration:3];
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
