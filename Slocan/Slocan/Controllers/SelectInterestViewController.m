//
//  SelectInterestViewController.m
//  Slocan
//
//  Created by Daud Abas on 29/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import "SelectInterestViewController.h"

@interface SelectInterestViewController ()

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (weak, nonatomic) IBOutlet UIButton *artsButton;
@property (weak, nonatomic) IBOutlet UIButton *entertainmentButton;
@property (weak, nonatomic) IBOutlet UIButton *eventsButton;
@property (weak, nonatomic) IBOutlet UIButton *foodButton;
@property (weak, nonatomic) IBOutlet UIButton *outdoorButton;
@property (weak, nonatomic) IBOutlet UIButton *shopButton;

@property (assign) NSInteger interestCount;

@end

@implementation SelectInterestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.interestCount = 0;
    // Do any additional setup after loading the view.
    
    [self.confirmButton setEnabled:NO];
    [self.navigationItem setHidesBackButton:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)skipSelectInterest:(id)sender {
    if ([self.delegate conformsToProtocol:@protocol(SignupDelegate)]) {
        [self.delegate didSignupFrom:self];
    }
    [self dismissOnboarding];
}

- (IBAction)toggleInterest:(id)sender {
    UIButton *selectedButton = (UIButton *)sender;
    if ([selectedButton isSelected]) {
        [selectedButton setSelected:NO];
        self.interestCount--;
        selectedButton.alpha = 1.0f;
    }
    else {
        [selectedButton setSelected:YES];
        self.interestCount++;
        selectedButton.alpha = 0.2f;
    }
    
    if (self.interestCount >= 3) {
        [self.confirmButton setTitle:NSLocalizedString(@"3 items selected. Let's go!", nil) forState:UIControlStateNormal];
        [self.confirmButton setEnabled:YES];
    }
    else {
        [self.confirmButton setTitle:NSLocalizedString(@"Please select 3 interests!", nil) forState:UIControlStateNormal];
    }
}

- (void)dismissOnboarding {
    if ([self.delegate conformsToProtocol:@protocol(SignupDelegate)]) {
        [self.delegate didSignupFrom:self];
    }
}

- (IBAction)dismissWithoutInterest:(id)sender {
    [self dismissOnboarding];
}

- (IBAction)dismissWithInterest:(id)sender {
    [self dismissOnboarding];
}

@end
