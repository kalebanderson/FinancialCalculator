//
//  SecondViewController.m
//  FinancialCalculator
//
//  Created by Raikes Design Studio on 11/20/13.
//  Copyright (c) 2013 Kaleb Anderson. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@property (weak, nonatomic) IBOutlet UITextField *PVofAnnuityTextField;
@property (weak, nonatomic) IBOutlet UITextField *CashFlowTextField;
@property (weak, nonatomic) IBOutlet UITextField *InterestRateTextField;
@property (weak, nonatomic) IBOutlet UITextField *MaturityTextField;
@property (weak, nonatomic) IBOutlet UITextField *CompoundsTextField;
@property (weak, nonatomic) IBOutlet UITextField *ResultTextField;

- (IBAction)SubmitAnnuityInfo:(id)sender;

- (double)solveForCashFlow;
- (double)solveForInterestRate;
- (double)solveForMaturity;
- (double)solveForPV;

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.ResultTextField.enabled = NO;
    
    /*
     Add a tap gesture recognizer to capture all tap events. This is primarily tap events when a
     user clicks outside of a text field.
     */
    self.backgroundTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(onBackgroundTap:)];
    self.backgroundTapGestureRecognizer.numberOfTapsRequired = 1;
    self.backgroundTapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:self.backgroundTapGestureRecognizer];
    
    /*
     Tie into the gesture recognizer's delegate method in order to stop the endEditing call from
     being made when the keyboard should not be dismissed.
     */
    [self.backgroundTapGestureRecognizer setDelegate:self];
}

/**
 |onBackgroundTap| specifies an action to be taken when a background tap is recognized.
 */
- (void)onBackgroundTap:(id)sender{
    // Call endEditing on the view controller's view, dismissing the keyboard.
    [[self view] endEditing:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SubmitAnnuityInfo:(id)sender
{
    if ([self.CashFlowTextField.text isEqualToString:@""])
    {
        self.ResultTextField.text = [NSString stringWithFormat:@"%9.2f",[self solveForCashFlow]];
    }
    else if ([self.InterestRateTextField.text isEqualToString:@""])
    {
        self.ResultTextField.text = [NSString stringWithFormat:@"%9.4f",[self solveForInterestRate]];
    }
    else if ([self.MaturityTextField.text isEqualToString:@""])
    {
        self.ResultTextField.text = [NSString stringWithFormat:@"%9.2f",[self solveForMaturity]];
    }
    else if ([self.PVofAnnuityTextField.text isEqualToString:@""])
    {
        self.ResultTextField.text = [NSString stringWithFormat:@"%9.2f",[self solveForPV]];
    }
    else
    {
        // Display alert because they entered text into all fields!
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Input Entry Error"
                              message:@"You entered values for all four fields. Leave one field empty!"
                              delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    if ([self.ResultTextField.text doubleValue] < -100)
    {
        self.ResultTextField.text = @"Error!";
    }
}

- (double)solveForCashFlow
{
    double cashFlow = -101;
    double PV = self.PVofAnnuityTextField.text.doubleValue;
    double maturity = self.MaturityTextField.text.doubleValue;
    double interestRate = self.InterestRateTextField.text.doubleValue/100.0;
    double compounds = self.CompoundsTextField.text.doubleValue;
    
    cashFlow = (PV*(interestRate/compounds)*pow(1+interestRate/compounds, maturity*compounds))/
                (pow(1+interestRate/compounds, maturity*compounds)-1);
    
    return cashFlow;
}

- (double)solveForInterestRate
{
    double PV = self.PVofAnnuityTextField.text.doubleValue;
    double maturity = self.MaturityTextField.text.doubleValue;
    double cashFlow = self.CashFlowTextField.text.doubleValue;
    double compounds = self.CompoundsTextField.text.doubleValue;
    
    double leftBound = -.5;
    double rightBound = 1;
    double midpoint = .75;
    double margin = .0001;
    double functionCalculation = -1;
    double functionCalculationLeftBound = -1;
    int maxNumberOfIterations = 10000;
    
    
    int n = 1;
    while (n <= maxNumberOfIterations)
    {
        midpoint = (leftBound+rightBound)/2;
        
        functionCalculation = cashFlow*compounds*(1-pow(1+midpoint/compounds, -1*maturity*compounds))/midpoint - PV;
        functionCalculationLeftBound = cashFlow*compounds*(1-pow(1+leftBound/compounds, -1*maturity*compounds))/leftBound - PV;
        
        if ((functionCalculation >= 0 && functionCalculation < margin) ||
            (functionCalculation <= 0 && functionCalculation > -1*margin))
        {
            return 100.0*midpoint;
        }
        
        if ((functionCalculation < 0 && functionCalculationLeftBound < 0) ||
            (functionCalculation > 0 && functionCalculationLeftBound > 0))
        {
            leftBound = midpoint;
        }
        else
        {
            rightBound = midpoint;
        }
        n++;
    }
    
    return -101;
}

- (double)solveForMaturity
{
    double cashFlow = self.CashFlowTextField.text.doubleValue;
    double PV = self.PVofAnnuityTextField.text.doubleValue;
    double interestRate = self.InterestRateTextField.text.doubleValue/100.0;
    double compounds = self.CompoundsTextField.text.doubleValue;
    
    double leftBound = 1;
    double rightBound = 149;
    double midpoint = 75;
    double margin = .001;
    double functionCalculation = -1;
    double functionCalculationLeftBound = -1;
    int maxNumberOfIterations = 1000;
    
    
    int n = 1;
    while (n <= maxNumberOfIterations)
    {
        midpoint = (leftBound+rightBound)/2;
        
        functionCalculation = cashFlow*compounds*(1-pow(1+interestRate/compounds, -1*midpoint*compounds))/interestRate - PV;
        functionCalculationLeftBound = cashFlow*compounds*(1-pow(1+interestRate/compounds, -1*leftBound*compounds))/interestRate - PV;
        
        if ((functionCalculation >= 0 && functionCalculation < margin) ||
            (functionCalculation <= 0 && functionCalculation > -1*margin))
        {
            return midpoint;
        }
        
        if ((functionCalculation < 0 && functionCalculationLeftBound < 0) ||
            (functionCalculation > 0 && functionCalculationLeftBound > 0))
        {
            leftBound = midpoint;
        }
        else
        {
            rightBound = midpoint;
        }
        n++;
    }
    
    return -101;
}

- (double)solveForPV
{
    double PV = -101;
    double cashFlow = self.CashFlowTextField.text.doubleValue;
    double maturity = self.MaturityTextField.text.doubleValue;
    double interestRate = self.InterestRateTextField.text.doubleValue/100.0;
    double compounds = self.CompoundsTextField.text.doubleValue;
    
    PV = cashFlow*compounds*(1-pow(1+interestRate/compounds, -1*maturity*compounds))/interestRate;
    
    return PV;
}

@end
