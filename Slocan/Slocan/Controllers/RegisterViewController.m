//
//  RegisterViewController.m
//  Slocan
//
//  Created by Jesse Armand on 29/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import "RegisterViewController.h"
#import "SLCPickerToolbar.h"
#import "SelectInterestViewController.h"

#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "UIFont+AppFonts.h"

NSString *const SlocanUserID = @"SlocanUserID";
NSString *const SlocanAccessToken = @"SlocanAccessToken";

NSString *const SlocanBaseURL = @"http://slocan.herokuapp.com";
NSString *const SlocanUserPath = @"/api/v1/users";

@interface RegisterViewController () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic) NSArray *countries;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;

@property (nonatomic) NSInteger age;
@property (copy, nonatomic) NSString *country;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self customizeTextFields];
    
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

- (void)customizeTextFields {
    //Use attributed string to change the placeholder's color.
    NSDictionary *attributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor] };
    
    NSAttributedString *nameString = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"What's your name?", nil) attributes:attributes];
    self.nameTextField.attributedPlaceholder = nameString;

    NSAttributedString *ageString = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Please select an age group", nil) attributes:attributes];
    self.ageTextField.attributedPlaceholder = ageString;

    NSAttributedString *countryString = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Which country are you from?", nil) attributes:attributes];
    self.countryTextField.attributedPlaceholder = countryString;
}

- (void)userExistsAlert {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"You have signed up previously", nil)
                                                        message:NSLocalizedString(@"You can continue to use the app with your existing data.", nil)
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    [alertView show];
}

- (IBAction)signupAction:(id)sender {
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
                    
                    [self showSelectInterest];
                    
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
                        
                        [self showSelectInterest];
                        
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

- (void)showSelectInterest {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Onboard" bundle:nil] ;
    
    SelectInterestViewController *selectInterestViewController = [storyboard instantiateViewControllerWithIdentifier:@"SelectInterestViewController"];
    selectInterestViewController.delegate = self.delegate;
    
    [self.navigationController pushViewController:selectInterestViewController animated:YES];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:46.0f/255 green:36.0f/255 blue:54.0f/255 alpha:1.0f]];
    
    NSDictionary *titleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont appBookFontOfSize:20.f], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont appBookFontOfSize:15.f], NSFontAttributeName,
                                     [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [[UINavigationBar appearance] setTitleTextAttributes:titleAttributes];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    self.navigationController.navigationBarHidden = NO;
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
    
    textField.inputAccessoryView = toolbar;
}

- (void)dismissCountryPicker:(id)sender {
    
    if ([self.countryTextField isFirstResponder]) {
        [self.countryTextField resignFirstResponder];
    }
    else if ([self.nameTextField isFirstResponder]) {
        [self.nameTextField resignFirstResponder];
    }
    else {
        [self.ageTextField resignFirstResponder];
    }
    
}

#pragma mark - PickerView delegates

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.countryTextField.text = self.countries[(NSUInteger)row][@"name"];
}

#pragma mark - PickerView datasource

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
