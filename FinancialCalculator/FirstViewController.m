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
@property (weak, nonatomic) IBOutlet UITextField *MaturityTextField;
@property (weak, nonatomic) IBOutlet UITextField *CompoundsTextField;
@property (weak, nonatomic) IBOutlet UITextField *PriceTextField;
@property (weak, nonatomic) IBOutlet UITextField *ResultTextField;

- (IBAction)SubmitBondInfo:(id)sender;

- (double)solveForFaceValue;
- (double)solveForDiscountRate;
- (double)solveForCouponRate;
- (double)solveForMaturity;
- (double)solveForPrice;

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Do any additional setup after loading the view.
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

- (IBAction)SubmitBondInfo:(id)sender
{
    if ([self.FaceValueTextField.text isEqualToString:@""])
    {
        self.ResultTextField.text = [NSString stringWithFormat:@"%9.2f",[self solveForFaceValue]];
    }
    else if ([self.DiscountRateTextField.text isEqualToString:@""])
    {
        self.ResultTextField.text = [NSString stringWithFormat:@"%9.4f",[self solveForDiscountRate]];
    }
    else if ([self.CouponRateTextField.text isEqualToString:@""])
    {
        self.ResultTextField.text = [NSString stringWithFormat:@"%9.4f",[self solveForCouponRate]];
    }
    else if ([self.MaturityTextField.text isEqualToString:@""])
    {
        double maturity = [self solveForMaturity];
        if (maturity == -999)
        {
            self.ResultTextField.text = @"Indeterminant.";
        }
        else
        {
            self.ResultTextField.text = [NSString stringWithFormat:@"%9.2f",maturity];
        }
    }
    else if ([self.PriceTextField.text isEqualToString:@""])
    {
        self.ResultTextField.text = [NSString stringWithFormat:@"%9.2f",[self solveForPrice]];
    }
    else
    {
        // Display alert because they entered text into all fields!
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Input Entry Error"
                               message:@"You entered values for all fields. Leave one field empty!"
                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    if (!([self.ResultTextField.text doubleValue] > -100))
    {
        self.ResultTextField.text = @"Error!";
    }
}

- (double)solveForFaceValue
{
    double compounds = self.CompoundsTextField.text.doubleValue;
    double discountRate = self.DiscountRateTextField.text.doubleValue/100.0;
    double maturity = self.MaturityTextField.text.doubleValue;
    double couponRate = self.CouponRateTextField.text.doubleValue/100.0;
    double price = self.PriceTextField.text.doubleValue;
    
    double discountedCouponPayments = (1.0/(discountRate/compounds) -
                                       1.0/(discountRate/compounds*pow(1+discountRate/compounds, maturity*compounds)));
    double maturityPaymentDiscountFactor = 1.0/pow(1.0+discountRate/compounds, maturity*compounds);
    
    return price/(couponRate*discountedCouponPayments + maturityPaymentDiscountFactor);
}

- (double)solveForDiscountRate
{
    double compounds = self.CompoundsTextField.text.doubleValue;
    double maturity = self.MaturityTextField.text.doubleValue;
    double couponRate = self.CouponRateTextField.text.doubleValue/100.0;
    double price = self.PriceTextField.text.doubleValue;
    double faceValue = self.FaceValueTextField.text.doubleValue;
    
    double couponPayment = couponRate*faceValue;
    
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
        yieldCalculation = couponPayment/(midpoint/compounds)-
                           couponPayment/(midpoint/compounds*pow(1+midpoint/compounds, maturity*compounds))+
                           faceValue/pow(1+midpoint/compounds, maturity*compounds) - price;
        
        yieldCalculationLeftBound = couponPayment/(leftBound/compounds)-
                                    couponPayment/(leftBound/compounds*pow(1+leftBound/compounds, maturity*compounds))+
                                    faceValue/pow(1+leftBound/compounds, maturity*compounds) - price;
        
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
    double compounds = self.CompoundsTextField.text.doubleValue;
    double maturity = self.MaturityTextField.text.doubleValue;
    double discountRate = self.DiscountRateTextField.text.doubleValue/100.0;
    double price = self.PriceTextField.text.doubleValue;
    double faceValue = self.FaceValueTextField.text.doubleValue;
    
    double maturityPayment = faceValue/(pow(1+discountRate/compounds,maturity*compounds));
    double discountedCouponPayments = (1.0/(discountRate/compounds) -
                                       1.0/(discountRate/compounds*pow(1+discountRate/compounds, maturity*compounds)));
    
    return 100.0*((price-maturityPayment)/discountedCouponPayments)/faceValue;
}

- (double)solveForMaturity
{
    double compounds = self.CompoundsTextField.text.doubleValue;
    double discountRate = self.DiscountRateTextField.text.doubleValue/100.0;
    double couponRate = self.CouponRateTextField.text.doubleValue/100.0;
    double price = self.PriceTextField.text.doubleValue;
    double faceValue = self.FaceValueTextField.text.doubleValue;
    
    double couponPayment = couponRate*faceValue;
    
    if (discountRate == couponRate)
    {
        return -999;
    }
    
    double leftBound = 1;
    double rightBound = 149;
    double midpoint = 75;
    double margin = .0001;
    double yearsCalculation = -1;
    double yearsCalculationLeftBound = -1;
    int maxNumberOfIterations = 1000;

    
    int n = 1;
    while (n <= maxNumberOfIterations)
    {
        midpoint = (leftBound+rightBound)/2;
        
        yearsCalculation = couponPayment/(discountRate/compounds)-
                couponPayment/(discountRate/compounds*pow(1+discountRate/compounds, midpoint*compounds))+
                faceValue/pow(1+discountRate/compounds, midpoint*compounds)-price;
        
        yearsCalculationLeftBound = couponPayment/(discountRate/compounds)-
                couponPayment/(discountRate/compounds*pow(1+discountRate/compounds, leftBound*compounds))+
                faceValue/pow(1+discountRate/compounds, leftBound*compounds)-price;
        
        if ((yearsCalculation >= 0 && yearsCalculation < margin) || (yearsCalculation <= 0 && yearsCalculation > -1*margin))
        {
            return midpoint;
        }
        
        if ((yearsCalculation < 0 && yearsCalculationLeftBound < 0) || (yearsCalculation > 0 && yearsCalculationLeftBound > 0))
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

- (double)solveForPrice
{
    double compounds = self.CompoundsTextField.text.doubleValue;
    double maturity = self.MaturityTextField.text.doubleValue;
    double discountRate = self.DiscountRateTextField.text.doubleValue/100.0;
    double faceValue = self.FaceValueTextField.text.doubleValue;
    double couponRate = self.CouponRateTextField.text.doubleValue/100.0;
    
    double couponPayment = couponRate*faceValue;
    double maturityPayment = faceValue/(pow(1+discountRate/compounds,maturity*compounds));
    double discountedCouponPayments = (1.0/(discountRate/compounds) - 1.0/(discountRate/compounds*
                                       pow(1+discountRate/compounds, maturity*compounds)));
    
    return couponPayment*discountedCouponPayments + maturityPayment;
}


@end
