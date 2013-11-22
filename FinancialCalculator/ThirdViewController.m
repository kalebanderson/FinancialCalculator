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
        self.ResultTextField.text = [NSString stringWithFormat:@"$ %f",[self solveForFutureValue]];
    }
    else if ([self.DiscountRateTextField.text isEqualToString:@""])
    {
        self.ResultTextField.text = [NSString stringWithFormat:@"%f %%",[self solveForDiscountRate]];
    }
    else if ([self.MaturityTextField.text isEqualToString:@""])
    {
        self.ResultTextField.text = [NSString stringWithFormat:@"%f",[self solveForMaturity]];
    }
    else if ([self.PresentValueTextField.text isEqualToString:@""])
    {
        self.ResultTextField.text = [NSString stringWithFormat:@"$ %f",[self solveForPresentValue]];
    }
    else
    {
        // Display alert because they entered text into all 4 fields!
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Input Entry Error"
                              message:@"You entered values for all four fields. Leave one field empty!"
                              delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    if (!([self.ResultTextField.text doubleValue] > -100))
    {
        self.ResultTextField.text = @"Error!";
    }
}

- (double)solveForFutureValue
{
    double futureValue = -101;
    
    
    return futureValue;
}

- (double)solveForDiscountRate
{
    double discountRate = -101;
    
    
    return discountRate;
}

- (double)solveForMaturity
{
    double maturity = -101;
    
    
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
                               message:@"You entered a maturity that is inconsistent with the number of cash flows."
                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
      
    return presentValue;
}

@end
