//
//  VcOutputViewController.m
//  FinancialCalculator
//
//  Created by Raikes Design Studio on 12/9/13.
//  Copyright (c) 2013 Kaleb Anderson. All rights reserved.
//

#import "VcOutputViewController.h"

@interface VcOutputViewController ()

- (IBAction)didGoBack:(id)sender;

@end

@implementation VcOutputViewController

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
    
    [self fillOutput];
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

- (void)fillOutput
{
    // Assignments for UILables. Intentional fallthrough depending on number of rounds of investment.
    switch (_numberOfRounds)
    {
        case 5:
            _fiveNewShares.text = _changeInShares[4];
            _fiveTotalShares.text = _totalShares[4];
            _fiveSharePrice.text = _sharePrices[4];
            _fiveEquityFraction.text = _equityFractions[4];
            
        case 4:
            _fourNewShares.text = _changeInShares[3];
            _fourTotalShares.text = _totalShares[3];
            _fourSharePrice.text = _sharePrices[3];
            _fourEquityFraction.text = _equityFractions[3];
            
        case 3:
            _threeNewShares.text = _changeInShares[2];
            _threeTotalShares.text = _totalShares[2];
            _threeSharePrice.text = _sharePrices[2];
            _threeEquityFraction.text = _equityFractions[2];
            
        case 2:
            _twoNewShares.text = _changeInShares[1];
            _twoTotalShares.text = _totalShares[1];
            _twoSharePrice.text = _sharePrices[1];
            _twoEquityFraction.text = _equityFractions[1];
        
        case 1:
            _oneNewShares.text = _changeInShares[0];
            _oneTotalShares.text = _totalShares[0];
            _oneSharePrice.text = _sharePrices[0];
            _oneEquityFraction.text = _equityFractions[0];
            break;
            
        default:
            // This was reached in error. Rounds of investing must be between 1 and 5.
            break;
    }
}

@end
