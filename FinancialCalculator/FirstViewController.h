//
//  FirstViewController.h
//  FinancialCalculator
//
//  Created by Raikes Design Studio on 11/20/13.
//  Copyright (c) 2013 Kaleb Anderson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController

/**
 recognizes a "background" tap, in this case a tap on the outside
 of the keyboard.
 */
@property(strong, nonatomic) UITapGestureRecognizer *backgroundTapGestureRecognizer;



@end
