//
//  VcOutputViewController.h
//  FinancialCalculator
//
//  Created by Raikes Design Studio on 12/9/13.
//  Copyright (c) 2013 Kaleb Anderson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VcOutputViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *exitSharePrice;
@property (weak, nonatomic) IBOutlet UILabel *exitEquityFraction;

@property (weak, nonatomic) IBOutlet UILabel *oneNewShares;
@property (weak, nonatomic) IBOutlet UILabel *oneTotalShares;
@property (weak, nonatomic) IBOutlet UILabel *oneSharePrice;
@property (weak, nonatomic) IBOutlet UILabel *oneEquityFraction;

@property (weak, nonatomic) IBOutlet UILabel *twoNewShares;
@property (weak, nonatomic) IBOutlet UILabel *twoSharePrice;
@property (weak, nonatomic) IBOutlet UILabel *twoTotalShares;
@property (weak, nonatomic) IBOutlet UILabel *twoEquityFraction;

@property (weak, nonatomic) IBOutlet UILabel *threeNewShares;
@property (weak, nonatomic) IBOutlet UILabel *threeTotalShares;
@property (weak, nonatomic) IBOutlet UILabel *threeSharePrice;
@property (weak, nonatomic) IBOutlet UILabel *threeEquityFraction;

@property (weak, nonatomic) IBOutlet UILabel *fourNewShares;
@property (weak, nonatomic) IBOutlet UILabel *fourTotalShares;
@property (weak, nonatomic) IBOutlet UILabel *fourSharePrice;
@property (weak, nonatomic) IBOutlet UILabel *fourEquityFraction;

@property (weak, nonatomic) IBOutlet UILabel *fiveNewShares;
@property (weak, nonatomic) IBOutlet UILabel *fiveTotalShares;
@property (weak, nonatomic) IBOutlet UILabel *fiveSharePrice;
@property (weak, nonatomic) IBOutlet UILabel *fiveEquityFraction;

@end
