//
//  RegisterViewController.h
//  Slocan
//
//  Created by Jesse Armand on 29/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SignupDelegate.h"

@interface RegisterViewController : UIViewController

@property (weak, nonatomic) id<SignupDelegate> delegate;

@end
