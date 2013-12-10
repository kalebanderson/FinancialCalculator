//
//  VcOutputViewController.m
//  FinancialCalculator
//
//  Created by Raikes Design Studio on 12/9/13.
//  Copyright (c) 2013 Kaleb Anderson. All rights reserved.
//

#import "VcOutputViewController.h"

@interface VcOutputViewController ()

- (IBAction)didGoBack:(id)sender;

@end

@implementation VcOutputViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didGoBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
