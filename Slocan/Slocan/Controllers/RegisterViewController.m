//
//  RegisterViewController.m
//  Slocan
//
//  Created by Jesse Armand on 29/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import "RegisterViewController.h"
#import "SLCPickerToolbar.h"

#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>

NSString *const SlocanUserID = @"SlocanUserID";
NSString *const SlocanAccessToken = @"SlocanAccessToken";

NSString *const SlocanBaseURL = @"http://slocan.herokuapp.com";
NSString *const SlocanUserPath = @"/api/v1/users";

@interface RegisterViewController () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic) NSArray *countries;

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
    
    UIPickerView *countryPickerView = [[UIPickerView alloc] init];
    countryPickerView.dataSource = self;
    countryPickerView.delegate = self;
    
    self.countryTextField.inputView = countryPickerView;
    
    NSString *countryFilePath = [[NSBundle mainBundle] pathForResource:@"countries" ofType:@"plist"];
    self.countries = [[NSArray alloc] initWithContentsOfFile:countryFilePath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)userExistsAlert {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"You have signed up previously", nil)
                                                        message:NSLocalizedString(@"You can continue to use the app with your existing data.", nil)
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    [alertView show];
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
                NSNumber *userId = responseDictionary[@"id"];
                NSNumber *age = responseDictionary[@"age"];
                NSString *country = responseDictionary[@"country_origin"];
                
                NSString *deviceToken = responseDictionary[@"device_id"];
                if ([deviceToken length] > 0) {
                    if ([age integerValue] != self.age || ![country isEqualToString:self.country]) {
                        [self userExistsAlert];
                    }
                    
                    [[NSUserDefaults standardUserDefaults] setInteger:[userId integerValue] forKey:SlocanUserID];
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
                        [self userExistsAlert];
                        
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

#pragma mark - Textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [self validateTextField:textField];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    SLCPickerToolbar *toolbar = [[[NSBundle mainBundle] loadNibNamed:@"SLCPickerToolbar" owner:self options:nil] objectAtIndex:0];
    
    [toolbar.doneButton setTarget:self];
    [toolbar.doneButton setAction:@selector(dismissCountryPicker:)];
    
    self.countryTextField.inputAccessoryView = toolbar;
}

- (void)dismissCountryPicker:(id)sender {
    [self.countryTextField resignFirstResponder];
}

#pragma - PickerView delegates

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.countryTextField.text = self.countries[(NSUInteger)row][@"name"];
}

#pragma - PickerView datasource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return (NSInteger)self.countries.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.countries[(NSUInteger)row][@"name"];
}

@end
