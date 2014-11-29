//
//  TabBarController.m
//  Slocan
//
//  Created by Hu Junfeng on 30/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import "TabBarController.h"

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundView.image = [UIImage imageNamed:@"MainBackground"];
    [self.view insertSubview:backgroundView atIndex:0];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
