//
//  ThirdViewController.m
//  FinancialCalculator
//
//  Created by Raikes Design Studio on 11/21/13.
//  Copyright (c) 2013 Kaleb Anderson. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()

@property (weak, nonatomic) IBOutlet UITextField *CashFlowTextField;
@property (weak, nonatomic) IBOutlet UITextField *DiscountRateTextField;
@property (weak, nonatomic) IBOutlet UITextField *MaturityTextField;
@property (weak, nonatomic) IBOutlet UITextField *PresentValueTextField;
@property (weak, nonatomic) IBOutlet UITextField *ResultTextField;

- (IBAction)SubmitPresentValueInfo:(id)sender;

- (double)solveForFutureValue;
- (double)solveForDiscountRate;
- (double)solveForMaturity;
- (double)solveForPresentValue;

@end

@implementation ThirdViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)SubmitPresentValueInfo:(id)sender
{
    if ([self.CashFlowTextField.text isEqualToString:@""])
    {
        self.ResultTextField.text = [NSString stringWithFormat:@"$ %9.2f",[self solveForFutureValue]];
    }
    else if ([self.DiscountRateTextField.text isEqualToString:@""])
    {
        self.ResultTextField.text = [NSString stringWithFormat:@"%9.4f %%",[self solveForDiscountRate]];
    }
    else if ([self.MaturityTextField.text isEqualToString:@""])
    {
        self.ResultTextField.text = [NSString stringWithFormat:@"%9.2f",[self solveForMaturity]];
    }
    else if ([self.PresentValueTextField.text isEqualToString:@""])
    {
        self.ResultTextField.text = [NSString stringWithFormat:@"$ %9.2f",[self solveForPresentValue]];
    }
    else
    {
        // Display alert because they entered text into all 4 fields!
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

- (double)solveForFutureValue
{
    double futureValue = -101;
    NSArray *presentValueCashFlows = [self.PresentValueTextField.text componentsSeparatedByString:@","];
    double discountRate = [self.DiscountRateTextField.text doubleValue]/100.0;
    double maturity = [self.MaturityTextField.text doubleValue];
    
    
    if (presentValueCashFlows.count == 1)
    {
        futureValue = 0;
        for (int i=1; i <= maturity; i++)
        {
            futureValue += [presentValueCashFlows[0] doubleValue]*pow(1+discountRate,i);
        }
    }
    else if (presentValueCashFlows.count == maturity)
    {
        futureValue = 0;
        for (int i=1; i <= presentValueCashFlows.count; i++)
        {
            futureValue += [presentValueCashFlows[i-1] doubleValue]*pow(1+discountRate, i);
        }
    }
    else
    {
        // Display alert because they entered number of periods different from list of cash flows
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Input Entry Error"
                               message:@"You entered a maturity that is inconsistent with the number"
                               @" of present value cash flows."
                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    return futureValue;
}

- (double)solveForDiscountRate
{
    double maturity = [self.MaturityTextField.text doubleValue];
    NSArray *cashFlows = [self.CashFlowTextField.text componentsSeparatedByString:@","];
    
    double leftBound = -.5;
    double rightBound = 1;
    double midpoint = .25;
    double margin = .00001;
    double functionCalculation = -500;
    double functionCalculationLeftBound = -500;
    int maxNumberOfIterations = 1000;
    
    int n = 1;
    while (n <= maxNumberOfIterations)
    {
        midpoint = (leftBound+rightBound)/2;
        functionCalculation = 0;
        functionCalculationLeftBound = 0;
        
        if (cashFlows.count == 1)
        {
            for (int i=1; i <= maturity; i++) {
                functionCalculation += [cashFlows[0] doubleValue]/pow(1+midpoint,i);
                functionCalculationLeftBound += [cashFlows[0] doubleValue]/pow(1+leftBound,i);
            }
        }
        else if (cashFlows.count == maturity)
        {
            for (int i=1; i <= cashFlows.count; i++)
            {
                functionCalculation += [cashFlows[i-1] doubleValue]/pow(1+midpoint,i);
                functionCalculationLeftBound += [cashFlows[i-1] doubleValue]/pow(1+leftBound,i);
            }
        }
        else
        {
            // Display alert because they entered number of periods different from list of cash flows
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Input Entry Error"
                                   message:@"You entered a maturity that is inconsistent with the number"
                                   @" of future cash flows."
                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
        functionCalculation -= self.PresentValueTextField.text.doubleValue;
        functionCalculationLeftBound    -= self.PresentValueTextField.text.doubleValue;
        
        if ((functionCalculation >= 0 && functionCalculation < margin) ||
            (functionCalculation <= 0 && functionCalculation > -1*margin))
        {
            return 100*midpoint;
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
    NSArray *cashFlows = [self.CashFlowTextField.text componentsSeparatedByString:@","];
    double discountRate = self.DiscountRateTextField.text.doubleValue/100.0;
    double maturity = -1;
    
    double leftBound = 1;
    double rightBound = 149;
    double midpoint = 75;
    double margin = .0001;
    double functionCalculation = -1;
    double functionCalculationLeftBound = -1;
    int maxNumberOfIterations = 1000;
    
    
    int n = 1;
    while (n <= maxNumberOfIterations)
    {
        midpoint = (leftBound+rightBound)/2;
        functionCalculation = 0;
        functionCalculationLeftBound = 0;
        
        if (cashFlows.count == 1)
        {
            for (int i=1; i <= midpoint; i++) {
                functionCalculation += [cashFlows[0] doubleValue]/pow(1+discountRate,i);
            }
            
            for (int j=1; j <= leftBound; j++)
            {
                functionCalculationLeftBound += [cashFlows[0] doubleValue]/pow(1+discountRate,j);
            }
        }
        else
        {
            return cashFlows.count;
        }
        
        functionCalculation -= self.PresentValueTextField.text.doubleValue;
        functionCalculationLeftBound    -= self.PresentValueTextField.text.doubleValue;

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
        maturity = midpoint;
        n++;
    }
    
    return maturity;
}

- (double)solveForPresentValue
{
    double presentValue = -101;
    NSArray *cashFlows = [self.CashFlowTextField.text componentsSeparatedByString:@","];
    double discountRate = [self.DiscountRateTextField.text doubleValue]/100.0;
    double maturity = [self.MaturityTextField.text doubleValue];
    
    if (cashFlows.count == 1)
    {
        presentValue = 0;
        for (int i=1; i <= maturity; i++) {
            presentValue += [cashFlows[0] doubleValue]/pow(1+discountRate,i);
        }
    }
    else if (cashFlows.count == maturity)
    {
        presentValue = 0;
        for (int i=1; i <= cashFlows.count; i++)
        {
            presentValue += [cashFlows[i-1] doubleValue]/pow(1+discountRate, i);
        }
    }
    else
    {
        // Display alert because they entered number of periods different from list of cash flows
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Input Entry Error"
                               message:@"You entered a maturity that is inconsistent with the number"
                               @" of future cash flows."
                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
      
    return presentValue;
}

@end
