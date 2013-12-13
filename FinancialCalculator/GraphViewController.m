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
{
    NSMutableArray *graphPoints;
}


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
    
    // Create long press gesture recognizer(gestureHandler will be triggered after gesture is detected)
    UILongPressGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc]
                                                      initWithTarget:self action:@selector(gestureHandler:)];
    [longPressGesture setMinimumPressDuration:1.5];
    [self.view addGestureRecognizer:longPressGesture];
    
    graphPoints = [[NSMutableArray alloc] init];
    [self calculateGraphPoints];
    
    OVGraphView *graphview=[[OVGraphView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) ContentSize:CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    
    [self.view addSubview:graphview];
    [graphview setPoints:graphPoints];
}

-(void)gestureHandler:(UISwipeGestureRecognizer *)gesture
{
    if(UIGestureRecognizerStateBegan == gesture.state)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)calculateGraphPoints
{
    int powerOfTenToDivideBy = 0;
    double tempVcEquity = _fvOfVcInvestments;
    while (tempVcEquity > 100)
    {
        tempVcEquity /= 10;
        powerOfTenToDivideBy++;
    }
    int numberToDivideBy = pow(10, powerOfTenToDivideBy);
    
    // Add starting investment.
    OVGraphViewPoint *point = [[OVGraphViewPoint alloc] initWithXLabel:@"Now"
                                YValue:[NSNumber numberWithDouble:[_investments[0] doubleValue]/numberToDivideBy]];
    [graphPoints addObject:point];
    
    int currentIndex = 1;
    for (int i=1; i<[_yearsToExit[0] intValue]; i++)
    {
        if (currentIndex < _yearsToExit.count)
        {
            if (i == ([_yearsToExit[0] intValue] - [_yearsToExit[currentIndex] doubleValue]))
            {
                OVGraphViewPoint *point = [[OVGraphViewPoint alloc] initWithXLabel:[NSString stringWithFormat:@"%d", i]
                                           YValue:[NSNumber numberWithDouble:[_investments[currentIndex] doubleValue]/numberToDivideBy]];
                [graphPoints addObject:point];
                currentIndex++;
            }
        }
        else
        {
            OVGraphViewPoint *point = [[OVGraphViewPoint alloc] initWithXLabel:[NSString stringWithFormat:@"%d", i] YValue:0];
            [graphPoints addObject:point];
        }
    }
    
    // Add payout (equity) of investors on exit.
    OVGraphViewPoint *endPoint = [[OVGraphViewPoint alloc] initWithXLabel:@"Exit"
                                   YValue:[NSNumber numberWithDouble:_fvOfVcInvestments/numberToDivideBy]];
    [graphPoints addObject:endPoint];
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
