//
//  VcOutputViewController.m
//  FinancialCalculator
//
//  Created by Raikes Design Studio on 12/9/13.
//  Copyright (c) 2013 Kaleb Anderson. All rights reserved.
//

#import "VcOutputViewController.h"
#import "GraphViewController.h"

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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self calculateGraphData];
    // Before segue, calculate and give GraphViewController data.
    
    ((GraphViewController *)segue.destinationViewController).numberOfRounds = _numberOfRounds;
    ((GraphViewController *)segue.destinationViewController).yearsToExit = _yearsToExit;
    ((GraphViewController *)segue.destinationViewController).investments = _investments;
    ((GraphViewController *)segue.destinationViewController).fvOfVcInvestments = _totalValVcEquity;
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
            _fiveNewShares.text = [_changeInShares[4] stringValue];
            _fiveTotalShares.text = [_totalShares[4] stringValue];
            _fiveSharePrice.text = [NSString stringWithFormat:@"$ %9.2f",[_sharePrices[4] doubleValue]];
            _fiveEquityFraction.text = _equityFractions[4];
            
        case 4:
            _fourNewShares.text = [_changeInShares[3] stringValue];
            _fourTotalShares.text = [_totalShares[3] stringValue];
            _fourSharePrice.text = [NSString stringWithFormat:@"$ %9.2f",[_sharePrices[3] doubleValue]];
            _fourEquityFraction.text = _equityFractions[3];
            
        case 3:
            _threeNewShares.text = [_changeInShares[2] stringValue];
            _threeTotalShares.text = [_totalShares[2] stringValue];
            _threeSharePrice.text = [NSString stringWithFormat:@"$ %9.2f",[_sharePrices[2] doubleValue]];
            _threeEquityFraction.text = _equityFractions[2];
            
        case 2:
            _twoNewShares.text = [_changeInShares[1] stringValue];
            _twoTotalShares.text = [_totalShares[1] stringValue];
            _twoSharePrice.text = [NSString stringWithFormat:@"$ %9.2f",[_sharePrices[1] doubleValue]];
            _twoEquityFraction.text = _equityFractions[1];
        
        case 1:
            _oneNewShares.text = [_changeInShares[0] stringValue];
            _oneTotalShares.text = [_totalShares[0] stringValue];
            _oneSharePrice.text = [NSString stringWithFormat:@"$ %9.2f",[_sharePrices[0] doubleValue]];
            _oneEquityFraction.text = _equityFractions[0];
            
            _exitSharePrice.text = [NSString stringWithFormat:@"$ %9.2f", [_sharePrices[_numberOfRounds-1] doubleValue]];
            _exitEquityFraction.text = [NSString stringWithFormat:@"$ %9.2f", _totalValVcEquity];
            _exitTotalEquity.text = [NSString stringWithFormat:@"$ %9.2f", _totalEquity];
            break;
            
        default:
            // This was reached in error. Rounds of investing must be between 1 and 5.
            break;
    }
}

- (void)calculateGraphData
{
    
}

@end
