//
//  MTViewController.m
//  MTShapes
//
//  Created by Adam Kirk on 9/1/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "MTViewController.h"
#import "MTTestView.h"




@interface MTViewController ()
@property (nonatomic, weak) IBOutlet MTTestView *testView;
@end




@implementation MTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)drawButtonPressed:(id)sender {
    [_testView draw];
}

@end
