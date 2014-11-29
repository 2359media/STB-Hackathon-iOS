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

@property (nonatomic) NSInteger age;
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
    // TODO: Sign-up and store a token or a confirmation that user has submitted age & country.
    BOOL valid = [self validateTextField:self.ageTextField];
    if (valid) {
        valid = [self validateTextField:self.countryTextField];
    }
    
    if (valid) {
        [[NSUserDefaults standardUserDefaults] setObject:@"authenticated" forKey:SlocanAccessToken];
        
        if ([self.delegate respondsToSelector:@selector(didSignupFrom:)]) {
            [self.delegate didSignupFrom:self];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)validateTextField:(UITextField *)textField {
    NSString *errorMessage = @"";
    BOOL shouldReturn = YES;
    
    if ([textField isEqual:self.ageTextField]) {
        shouldReturn = ([textField.text integerValue] > 0);
        if (!shouldReturn) {
            errorMessage = NSLocalizedString(@"Please enter a valid age.", nil);
        }
        else {
            self.age = [textField.text integerValue];
        }
    } else if ([textField isEqual:self.countryTextField]) {
        shouldReturn = [textField.text length] > 0;
        
        if (!shouldReturn) {
            errorMessage = NSLocalizedString(@"Please enter a valid country.", nil);
        }
        else {
            self.country = textField.text;
        }
    }
    
    if (!shouldReturn) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Please enter a valid data", nil)
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        [alertView show];
    }
    
    return shouldReturn;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [self validateTextField:textField];
}

@end
