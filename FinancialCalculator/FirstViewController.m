//
//  FirstViewController.m
//  FinancialCalculator
//
//  Created by Raikes Design Studio on 11/20/13.
//  Copyright (c) 2013 Kaleb Anderson. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@property (weak, nonatomic) IBOutlet UITextField *FaceValueTextField;
@property (weak, nonatomic) IBOutlet UITextField *DiscountRateTextField;
@property (weak, nonatomic) IBOutlet UITextField *CouponRateTextField;
@property (weak, nonatomic) IBOutlet UITextField *YearsTextField;
@property (weak, nonatomic) IBOutlet UITextField *PriceTextField;
@property (weak, nonatomic) IBOutlet UITextField *ResultTextField;

- (IBAction)SubmitBondInfo:(id)sender;

- (double)solveForFaceValue;
- (double)solveForDiscountRate;
- (double)solveForCouponRate;
- (double)solveForYears;
- (double)solveForPrice;

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Do any additional setup after loading the view.
    
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

- (IBAction)SubmitBondInfo:(id)sender
{
    if ([self.FaceValueTextField.text isEqualToString:@""])
    {
        self.ResultTextField.text = [NSString stringWithFormat:@"$ %f",[self solveForFaceValue]];
    }
    else if ([self.DiscountRateTextField.text isEqualToString:@""])
    {
        self.ResultTextField.text = [NSString stringWithFormat:@"%f %%",[self solveForDiscountRate]];
    }
    else if ([self.CouponRateTextField.text isEqualToString:@""])
    {
        self.ResultTextField.text = [NSString stringWithFormat:@"%f %%",[self solveForCouponRate]];
    }
    else if ([self.YearsTextField.text isEqualToString:@""])
    {
        self.ResultTextField.text = [NSString stringWithFormat:@"%f",[self solveForYears]];
    }
    else if ([self.PriceTextField.text isEqualToString:@""])
    {
        self.ResultTextField.text = [NSString stringWithFormat:@"$ %f",[self solveForPrice]];
    }
    else
    {
        // Display alert because they entered text into all 5 fields!
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Input Entry Error"
                               message:@"You entered values for all five fields. Leave one field empty!"
                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}

- (double)solveForFaceValue
{
    double discountedCouponPayments = (1.0/([self.DiscountRateTextField.text doubleValue]/100.0) -
                                       1.0/(([self.DiscountRateTextField.text doubleValue]/100.0)*
        pow(1+[self.DiscountRateTextField.text doubleValue]/100.0,[self.YearsTextField.text doubleValue])));
    double maturityPaymentDiscountFactor = 1.0/pow(1.0+[self.DiscountRateTextField.text doubleValue]/100.0,
                                               [self.YearsTextField.text doubleValue]);
    
    return [self.PriceTextField.text doubleValue]/(([self.CouponRateTextField.text doubleValue]/100.0)*
            discountedCouponPayments + maturityPaymentDiscountFactor);
}

- (double)solveForDiscountRate
{
    double couponPayment = [self.CouponRateTextField.text doubleValue]/100.0*[self.FaceValueTextField.text doubleValue];
    
    double leftBound = -.5;
    double rightBound = 1;
    double midpoint = .25;
    double margin = .00001;
    double yieldCalculation = -500;
    double yieldCalculationLeftBound = -500;
    int maxNumberOfIterations = 1000;
    
    int n = 1;
    while (n <= maxNumberOfIterations)
    {
        midpoint = (leftBound+rightBound)/2;
        yieldCalculation = couponPayment/midpoint-
                           couponPayment/(midpoint*pow(1+midpoint, [self.YearsTextField.text doubleValue]))+
                           [self.FaceValueTextField.text doubleValue]/pow(1+midpoint, [self.YearsTextField.text doubleValue])-
                           [self.PriceTextField.text doubleValue];
        
        yieldCalculationLeftBound = couponPayment/leftBound-
                            couponPayment/(leftBound*pow(1+leftBound, [self.YearsTextField.text doubleValue]))+
                            [self.FaceValueTextField.text doubleValue]/pow(1+leftBound, [self.YearsTextField.text doubleValue])-
                            [self.PriceTextField.text doubleValue];
        
        if ((yieldCalculation >= 0 && yieldCalculation < margin) || (yieldCalculation <= 0 && yieldCalculation > -1*margin))
        {
            return 100*midpoint;
        }
        
        if ((yieldCalculation < 0 && yieldCalculationLeftBound < 0) || (yieldCalculation > 0 && yieldCalculationLeftBound > 0))
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

- (double)solveForCouponRate
{
    double maturityPayment = [self.FaceValueTextField.text doubleValue]/
        (pow(1+[self.DiscountRateTextField.text doubleValue]/100.0,[self.YearsTextField.text doubleValue]));
    double discountedCouponPayments = (1.0/([self.DiscountRateTextField.text doubleValue]/100.0) -
                                       1.0/(([self.DiscountRateTextField.text doubleValue]/100.0)*
         pow(1+[self.DiscountRateTextField.text doubleValue]/100.0,[self.YearsTextField.text doubleValue])));
    
    return 100.0*(([self.PriceTextField.text doubleValue]-maturityPayment)/discountedCouponPayments)/
         [self.FaceValueTextField.text doubleValue];
}

- (double)solveForYears
{
    return 103;
}

- (double)solveForPrice
{
    double couponPayment = [self.CouponRateTextField.text doubleValue]/100.0*[self.FaceValueTextField.text doubleValue];
    double maturityPayment = [self.FaceValueTextField.text doubleValue]/
        (pow(1+[self.DiscountRateTextField.text doubleValue]/100.0,[self.YearsTextField.text doubleValue]));
    double discountedCouponPayments = (1.0/([self.DiscountRateTextField.text doubleValue]/100.0) -
                                       1.0/(([self.DiscountRateTextField.text doubleValue]/100.0)*
         pow(1+[self.DiscountRateTextField.text doubleValue]/100.0,[self.YearsTextField.text doubleValue])));
    
    return couponPayment*discountedCouponPayments + maturityPayment;
}


@end
