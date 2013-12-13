//
//  FourthViewController.m
//  FinancialCalculator
//
//  Created by Raikes Design Studio on 12/9/13.
//  Copyright (c) 2013 Kaleb Anderson. All rights reserved.
//

#import "FourthViewController.h"
#import "VcOutputViewController.h"

@interface FourthViewController ()

- (IBAction)didSubmitVcInput:(id)sender;

@end

@implementation FourthViewController
{
    NSArray *years;
    NSArray *investments;
    NSArray *roi;
    NSMutableArray *newShares;
    NSMutableArray *totalShares;
    NSMutableArray *sharePrices;
    NSMutableArray *equityFractions;
    NSMutableArray *ownershipPercentages;
    double numberOfRounds;
    int totalSharesTemp;
    double totalVcEquity;
}

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
    
    newShares = [[NSMutableArray alloc] init];
    totalShares = [[NSMutableArray alloc] init];
    sharePrices = [[NSMutableArray alloc] init];
    equityFractions = [[NSMutableArray alloc] init];
    ownershipPercentages = [[NSMutableArray alloc] init];
    
    UIEdgeInsets inset = UIEdgeInsetsMake(18, 0, 49, 0);
    self.tableView.contentInset = inset;
    
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

- (IBAction)didSubmitVcInput:(id)sender
{
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Empty arrays in case there are leftovers from previous calculations.
    [newShares removeAllObjects];
    [totalShares removeAllObjects];
    [sharePrices removeAllObjects];
    [equityFractions removeAllObjects];
    
    [self setupInputArrays];
    numberOfRounds = [self determineNumberOfRounds];
    
    if (numberOfRounds > 0)
    {
        [self calculateVcOutput];
        //[self performSegueWithIdentifier:@"segueToVcOutput" sender:self];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Input Entry Error"
                              message:@"You must enter at least one round of investing!"
                              delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    // Before segue, give VcOutputViewController output data.
    ((VcOutputViewController *)segue.destinationViewController).numberOfRounds = numberOfRounds;
    ((VcOutputViewController *)segue.destinationViewController).totalEquity = [_peExit.text doubleValue]*[_earningsExit.text doubleValue];
    ((VcOutputViewController *)segue.destinationViewController).changeInShares = newShares;
    ((VcOutputViewController *)segue.destinationViewController).totalShares = totalShares;
    ((VcOutputViewController *)segue.destinationViewController).sharePrices = sharePrices;
    ((VcOutputViewController *)segue.destinationViewController).equityFractions = equityFractions;
    
    // Also give some data for the graph.
    ((VcOutputViewController *)segue.destinationViewController).yearsToExit = years;
    ((VcOutputViewController *)segue.destinationViewController).investments = investments;
    ((VcOutputViewController *)segue.destinationViewController).totalValVcEquity = totalVcEquity;
}

- (void)setupInputArrays
{
    years = @[_roundOneYears.text, _roundTwoYears.text, _roundThreeYears.text,
                    _roundFourYears.text, _roundFiveYears.text];
    investments = @[_roundOneInvestment.text, _roundTwoInvestment.text, _roundThreeInvestment.text,
                    _roundFourInvestment.text, _roundFiveInvestment.text];
    roi = @[_roundOneRoi.text, _roundTwoRoi.text, _roundThreeRoi.text,
                    _roundFourRoi.text, _roundFiveRoi.text];
}

- (int)determineNumberOfRounds
{
    int temp = 0;
    
    for (int i=0; i<5; i++)
    {
        if ([years[i] doubleValue] > 0 && [investments[i] doubleValue] > 0 && [roi[i] doubleValue] > 0)
        {
            temp++;
        }
    }
    return temp;
}

- (void)calculateOwnershipPercentagesWithEquity:(double)equity
{
    NSMutableArray *finalEquityPercentages = [[NSMutableArray alloc] init];
    
    for (int i=0; i<numberOfRounds; i++)
    {
        double finalEquityPercent = [investments[i] doubleValue]*pow(1+[roi[i] doubleValue]/100, [years[i] doubleValue])/equity;
        [finalEquityPercentages addObject:[NSNumber numberWithDouble:finalEquityPercent]];
    }
    
    while (finalEquityPercentages.count > 0)
    {
        double tempEquityPercent = [[finalEquityPercentages firstObject] doubleValue];
        [finalEquityPercentages removeObjectAtIndex:0];
        double tempRetentionPercent = 1;        // 1 = 100%
        
        for (int j=0; j < finalEquityPercentages.count; j++)
        {
            tempRetentionPercent -= [finalEquityPercentages[j] doubleValue];
        }
        
        tempEquityPercent /= tempRetentionPercent;
        
        [ownershipPercentages addObject:[NSNumber numberWithDouble:tempEquityPercent]];
    }

}

- (void)calculateVcOutput
{
    totalSharesTemp = [_numberOfShares.text intValue];
    totalVcEquity = 0;
    
    double equity = [_earningsExit.text doubleValue]*[_peExit.text doubleValue];
    [self calculateOwnershipPercentagesWithEquity:equity];
    
    for (int i=0; i<numberOfRounds; i++)
    {
        double vcEquityPercent = [investments[i] doubleValue]*pow(1+[roi[i] doubleValue]/100, [years[i] doubleValue])/equity;
        int newShrs = round([ownershipPercentages[i] doubleValue]*totalSharesTemp/(1-[ownershipPercentages[i] doubleValue]));
        
        // Set total number of shares and update the running total.
        int totShares = round(totalSharesTemp + newShrs);
        totalSharesTemp = totShares;
        double sharePrc = equity/totShares;
        
        NSString *equityFraction = [NSString stringWithFormat:@"$ %9.2f", vcEquityPercent*equity];
        totalVcEquity += vcEquityPercent*equity;
        
        [newShares addObject:[NSNumber numberWithInt:newShrs]];
        [totalShares addObject:[NSNumber numberWithInt:totShares]];
        [sharePrices addObject:[NSNumber numberWithDouble:sharePrc]];
        [equityFractions addObject:equityFraction];
    }
}

@end
