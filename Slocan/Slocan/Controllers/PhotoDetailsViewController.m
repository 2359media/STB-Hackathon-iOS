//
//  PhotoDetailsViewController.m
//  Slocan
//
//  Created by Jesse Armand on 29/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import "PhotoDetailsViewController.h"

#import <AFNetworking/AFNetworking.h>
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

#pragma mark - Vote API

- (void)votePhotoWithID:(NSInteger)photoId asLiked:(BOOL)liked {
    // User never saved its user_id, we assume this is only happening on development device.
    // Set it to 1.
    NSInteger userId = [[NSUserDefaults standardUserDefaults] integerForKey:SlocanUserID];
    if (userId == 0) {
        userId = 1;
    }
    
    NSDictionary *parameters = @{
                                 @"photo_id": @(photoId),
                                 @"user_id": @(userId),
                                 @"liked": @(liked)
                               };
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:SlocanBaseURL]];
    [sessionManager POST:SlocanVotesPath parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }
    }];
}

#pragma mark - Toolbar

- (void)toolbarViewDidClose:(SLCToolbarView *)buttonView {
    [self willMoveToParentViewController:nil];
    
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        
        if ([self.delegate respondsToSelector:@selector(photoDetailsViewDidClose)]) {
            [self.delegate photoDetailsViewDidClose];
        }
    }];
}

- (void)toolbarViewDidLiked:(SLCToolbarView *)buttonView {
    [self votePhotoWithID:[self.photo[@"id"] integerValue] asLiked:YES];
}

- (void)toolbarViewDidNoped:(SLCToolbarView *)buttonView {
    [self votePhotoWithID:[self.photo[@"id"] integerValue] asLiked:NO];
}

@end
