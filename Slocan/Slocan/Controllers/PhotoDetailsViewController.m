//
//  PhotoDetailsViewController.m
//  Slocan
//
//  Created by Jesse Armand on 29/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import "PhotoDetailsViewController.h"

#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIFont+AppFonts.h"

#import "SLCToolbarView.h"

@interface PhotoDetailsViewController () <SLCToolbarViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *venueNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueTipLabel;
@property (weak, nonatomic) IBOutlet SLCToolbarView *toolbarView;

@end

@implementation PhotoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.venueNameLabel.font = [UIFont appBookFontOfSize:self.venueNameLabel.font.pointSize];
    self.venueNameLabel.textColor = [UIColor whiteColor];
    self.venueNameLabel.text = @"";
    self.venueAddressLabel.font = [UIFont appLightFontOfSize:self.venueAddressLabel.font.pointSize];
    self.venueAddressLabel.textColor = [UIColor whiteColor];
    self.venueAddressLabel.text = @"";
    self.venueTipLabel.font = [UIFont appLightFontOfSize:self.venueTipLabel.font.pointSize];
    self.venueTipLabel.textColor = [UIColor whiteColor];
    self.venueTipLabel.text = @"";
    self.venueCategoryLabel.font = [UIFont appLightFontOfSize:self.venueCategoryLabel.font.pointSize];
    self.venueCategoryLabel.textColor = [UIColor colorWithHexString:@"#954B90"];
    self.venueCategoryLabel.text = @"";
    
    self.toolbarView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.photo != nil) {
        [self.photoImageView setImageWithURL:[NSURL URLWithString:self.photo[@"url"]] placeholderImage:nil];
        
        self.venueNameLabel.text = [self.photo valueForKeyPath:@"venue.name"];
        self.venueCategoryLabel.text = [[self.photo valueForKeyPath:@"venue.tags"] firstObject];
        
        self.venueAddressLabel.text = [self.photo valueForKeyPath:@"venue.address_blob"];
        self.venueTipLabel.text = [self.photo valueForKeyPath:@"venue.tip"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)toolbarViewDidClose:(SLCToolbarView *)buttonView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)toolbarViewDidLiked:(SLCToolbarView *)buttonView {
    
}

- (void)toolbarViewDidNoped:(SLCToolbarView *)buttonView {
    
}

@end
