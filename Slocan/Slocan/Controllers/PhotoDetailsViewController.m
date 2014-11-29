//
//  PhotoDetailsViewController.m
//  Slocan
//
//  Created by Jesse Armand on 29/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import "PhotoDetailsViewController.h"

#import <AFNetworking/UIImageView+AFNetworking.h>
#import <AXRatingView/AXRatingView.h>

@interface PhotoDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *venueNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueAddressLabel;
@property (weak, nonatomic) IBOutlet AXRatingView *venueRatingView;
@property (weak, nonatomic) IBOutlet UILabel *venueTipLabel;

@end

@implementation PhotoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.venueNameLabel.text = @"";
    self.venueAddressLabel.text = @"";
    self.venueTipLabel.text = @"";
    
    self.venueRatingView.hidden = YES;
    self.venueRatingView.value = 0.f;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.photo != nil) {
        [self.photoImageView setImageWithURL:[NSURL URLWithString:self.photo[@"url"]] placeholderImage:nil];
        
        self.venueNameLabel.text = [self.photo valueForKeyPath:@"venue.name"];
        self.venueAddressLabel.text = [self.photo valueForKeyPath:@"venue.address_blob"];
        
        float ratingValue = [[self.photo valueForKeyPath:@"venue.rating"] floatValue];
        float normalizedValue = (ratingValue * 0.1f) * 5.f;
        self.venueRatingView.hidden = NO;
        self.venueRatingView.value = normalizedValue;
        
        self.venueTipLabel.text = [self.photo valueForKeyPath:@"venue.tip"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
