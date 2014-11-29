//
//  RegisterViewController.m
//  Slocan
//
//  Created by Jesse Armand on 29/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import "RegisterViewController.h"

NSString *const SlocanAccessToken = @"SlocanAccessToken";

@interface RegisterViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;

@property (copy, nonatomic) NSString *age;
@property (copy, nonatomic) NSString *country;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Sign Up", nil)
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(signupAction:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)signupAction:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"authenticated" forKey:SlocanAccessToken];
    
    if ([self.delegate respondsToSelector:@selector(didSignupFrom:)]) {
        [self.delegate didSignupFrom:self];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

@end
