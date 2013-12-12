//
//  GraphViewController.m
//  FinancialCalculator
//
//  Created by Raikes Design Studio on 12/11/13.
//  Copyright (c) 2013 Kaleb Anderson. All rights reserved.
//

#import "GraphViewController.h"
#import "OVGraphView.h"
#import "OVGraphViewPoint.h"

@interface GraphViewController ()

- (IBAction)didGoBack:(id)sender;

@end

@implementation GraphViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    OVGraphView *graphview=[[OVGraphView alloc]initWithFrame:CGRectMake(0, 0, 480, 300) ContentSize:CGSizeMake(960, 300)];
    
    //customizations go here
    
    [self.view addSubview:graphview];
    
    [graphview setPoints:@[[[OVGraphViewPoint alloc]initWithXLabel:@"today" YValue:@3.2 ],[[OVGraphViewPoint alloc]initWithXLabel:@"yesterday" YValue:@4 ],[[OVGraphViewPoint alloc]initWithXLabel:@"3" YValue:@6 ]]];
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
