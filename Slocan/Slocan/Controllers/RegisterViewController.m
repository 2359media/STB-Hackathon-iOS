//
//  RegisterViewController.m
//  Slocan
//
//  Created by Jesse Armand on 29/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import "RegisterViewController.h"

#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>

NSString *const SlocanAccessToken = @"SlocanAccessToken";

NSString *const SlocanBaseURL = @"http://slocan.herokuapp.com";
NSString *const SlocanUserPath = @"/api/v1/users";

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
    BOOL valid = [self validateTextField:self.ageTextField];
    if (valid) {
        valid = [self validateTextField:self.countryTextField];
    }
    
    if (valid) {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"Signing Up...", nil) maskType:SVProgressHUDMaskTypeClear];
        
        NSString *deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSDictionary *parameters = @{ @"device_id": deviceId,
                                      @"age": @(self.age),
                                      @"country_origin": self.country };
        
        AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:SlocanBaseURL]];
        [sessionManager POST:SlocanUserPath parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@", responseObject);
            
            [SVProgressHUD dismiss];
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseDictionary = responseObject;
                NSString *deviceToken = responseDictionary[@"device_id"];
                if ([deviceToken length] > 0) {
                    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:SlocanAccessToken];
                    
                    if ([self.delegate respondsToSelector:@selector(didSignupFrom:)]) {
                        [self.delegate didSignupFrom:self];
                    }
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                } else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sign up failed", nil)
                                                                        message:NSLocalizedString(@"Please try again.", nil)
                                                                       delegate:nil
                                                              cancelButtonTitle:nil
                                                              otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
                    [alertView show];
                }
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (error) {
                NSData *errorData = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
                if ([errorData length] > 0) {
                    NSError *jsonError;
                    NSDictionary *errorDict = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingAllowFragments error:&jsonError];
                    NSLog(@"%@", errorDict);
                    
                    NSInteger statusCode = [errorDict[@"status_code"] integerValue];
                    if (statusCode == 4003) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"You have signed up", nil)
                                                                            message:NSLocalizedString(@"You can continue to use the app with your existing data.", nil)
                                                                           delegate:nil
                                                                  cancelButtonTitle:nil
                                                                  otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
                        [alertView show];

                        NSString *deviceToken = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
                        [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:SlocanAccessToken];
                        
                        if ([self.delegate respondsToSelector:@selector(didSignupFrom:)]) {
                            [self.delegate didSignupFrom:self];
                        }
                        
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                    
                } else {
                    NSLog(@"%@", error);
                }
            }
            
            [SVProgressHUD dismiss];
        }];
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
