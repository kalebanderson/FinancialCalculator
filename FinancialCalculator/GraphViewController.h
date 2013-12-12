//
//  GraphViewController.h
//  FinancialCalculator
//
//  Created by Raikes Design Studio on 12/11/13.
//  Copyright (c) 2013 Kaleb Anderson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphViewController : UIViewController


@property (nonatomic) int numberOfRounds;

/**
 Round 1 is assumed to occur at time=0, so that is the total number of years.
 */
@property (nonatomic) NSArray *yearsToExit;
@property (nonatomic) NSArray *investments;
@property (nonatomic) double fvOfVcInvestments;

@end
