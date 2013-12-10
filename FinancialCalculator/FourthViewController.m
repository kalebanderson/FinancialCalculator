//
//  FourthViewController.m
//  FinancialCalculator
//
//  Created by Raikes Design Studio on 12/9/13.
//  Copyright (c) 2013 Kaleb Anderson. All rights reserved.
//

#import "FourthViewController.h"

@interface FourthViewController ()

@property (weak, nonatomic) IBOutlet UITextField *numberOfShares;
@property (weak, nonatomic) IBOutlet UITextField *initialYears;
@property (weak, nonatomic) IBOutlet UITextField *peExit;
@property (weak, nonatomic) IBOutlet UITextField *earningsExit;

@property (weak, nonatomic) IBOutlet UITextField *roundOneYears;
@property (weak, nonatomic) IBOutlet UITextField *roundOneInvestment;
@property (weak, nonatomic) IBOutlet UITextField *roundOneRoi;

@property (weak, nonatomic) IBOutlet UITextField *roundTwoYears;
@property (weak, nonatomic) IBOutlet UITextField *roundTwoInvestment;
@property (weak, nonatomic) IBOutlet UITextField *roundTwoRoi;

@property (weak, nonatomic) IBOutlet UITextField *roundThreeYears;
@property (weak, nonatomic) IBOutlet UITextField *roundThreeInvestment;
@property (weak, nonatomic) IBOutlet UITextField *roundThreeRoi;

@property (weak, nonatomic) IBOutlet UITextField *roundFourYears;
@property (weak, nonatomic) IBOutlet UITextField *roundFourInvestment;
@property (weak, nonatomic) IBOutlet UITextField *roundFourRoi;

@property (weak, nonatomic) IBOutlet UITextField *roundFiveYears;
@property (weak, nonatomic) IBOutlet UITextField *roundFiveInvestment;
@property (weak, nonatomic) IBOutlet UITextField *roundFiveRoi;

@end

@implementation FourthViewController

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

@end
