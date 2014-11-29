//
//  SelectInterestViewController.m
//  Slocan
//
//  Created by Daud Abas on 29/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import "SelectInterestViewController.h"

@interface SelectInterestViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *skipButton;

@property (weak, nonatomic) IBOutlet UIButton *artsButton;
@property (weak, nonatomic) IBOutlet UIButton *entertainmentButton;
@property (weak, nonatomic) IBOutlet UIButton *eventsButton;
@property (weak, nonatomic) IBOutlet UIButton *foodButton;
@property (weak, nonatomic) IBOutlet UIButton *outdoorButton;
@property (weak, nonatomic) IBOutlet UIButton *shopButton;

@end

@implementation SelectInterestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setHidesBackButton:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)skipSelectInterest:(id)sender {
    if ([self.delegate conformsToProtocol:@protocol(SignupDelegate)]) {
        [self.delegate didSignupFrom:self];
    }
}

- (IBAction)toggleInterest:(id)sender {
    
}

@end
