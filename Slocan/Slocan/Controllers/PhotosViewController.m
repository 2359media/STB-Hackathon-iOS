//
//  PhotosViewController.m
//  Slocan
//
//  Created by Jesse Armand on 29/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import "PhotosViewController.h"
#import "RegisterViewController.h"
#import "SelectInterestViewController.h"

#import "PhotoDetailsViewController.h"

#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>

#import "SlocanPhotoView.h"

NSString *const SlocanPhotosPath = @"/api/v1/photos";
NSString *const SlocanVotesPath = @"/api/v1/votes";

NSString *const SlocanCurrentPhotoPage = @"SlocanCurrentPhotoPage";

static const CGFloat ChoosePhotoButtonHorizontalPadding = 80.f;
static const CGFloat ChoosePhotoButtonVerticalPadding = 20.f;

@interface PhotosViewController () <SignupDelegate, MDCSwipeToChooseDelegate, PhotoDetailsViewDelegate>

@property (nonatomic) NSInteger currentPage;

@property (nonatomic, copy) NSDictionary *currentPhoto;
@property (nonatomic, strong) SlocanPhotoView *frontCardView;
@property (nonatomic, strong) SlocanPhotoView *backCardView;

@property (nonatomic, strong) UIButton *informationButton;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *nopeButton;

@property (nonatomic, strong) NSMutableArray *photos;

@property (nonatomic, strong) UINavigationController *signUpNavigationController;
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;

@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentPage = [[NSUserDefaults standardUserDefaults] integerForKey:SlocanCurrentPhotoPage];
    if (self.currentPage == 0) {
        self.currentPage = 1;
    }
    
    if ([self.photos count] > 0) {
        [self loadCards];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    NSString *accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:SlocanAccessToken];
//    if ([accessToken length] == 0) {
        [self showSignUp];
//    } else {
//        if ([self.photos count] == 0) {
//            [self fetchPhotosAtPage:self.currentPage];
//        }
//    }
}

- (void)showSignUp {
    
    UIStoryboard *onboardStoryboard = [UIStoryboard storyboardWithName:@"Onboard" bundle:nil];
    RegisterViewController *viewController = [onboardStoryboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    viewController.delegate = self;
    
    self.signUpNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.signUpNavigationController.navigationBarHidden = YES;
    [self presentViewController:self.signUpNavigationController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Internal Methods

- (void)fetchPhotosAtPage:(NSInteger)page {
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Loading...", nil) maskType:SVProgressHUDMaskTypeClear];
    
    // User never saved its user_id, we assume this is only happening on development device.
    // Set it to 1.
    NSInteger userId = [[NSUserDefaults standardUserDefaults] integerForKey:SlocanUserID];
    if (userId == 0) {
        userId = 1;
    }
    
    NSDictionary *parameters = @{ @"user_id": @(userId), @"page": @(page) };
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:SlocanBaseURL]];
    [sessionManager GET:SlocanPhotosPath parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        
        NSLog(@"%@", responseObject);
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSArray *responseArray = responseObject;
            if ([responseArray count] > 0) {
                self.currentPage = page;
                
                [[NSUserDefaults standardUserDefaults] setInteger:page forKey:SlocanCurrentPhotoPage];
                
                self.photos = [responseArray mutableCopy];
                [self loadCards];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        
        if (error) {
            NSLog(@"%@", error);
        }
    }];
}

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

- (NSArray *)defaultPhotos {
    // It would be trivial to download these from a web service
    // as needed, but for the purposes of this sample app we'll
    // simply store them in memory.
    return @[
             @{
                 @"id": @(1),
                 @"url": @"http://photos-h.ak.instagram.com/hphotos-ak-xpa1/10809812_314522248740311_1728815139_n.jpg" },
             @{
                 @"id": @(2),
                 @"url": @"http://photos-h.ak.instagram.com/hphotos-ak-xpa1/10809812_314522248740311_1728815139_n.jpg" },
             @{
                 @"id": @(3),
                 @"url": @"http://photos-h.ak.instagram.com/hphotos-ak-xpa1/10809812_314522248740311_1728815139_n.jpg" },
             @{
                 @"id": @(1),
                 @"url": @"http://photos-h.ak.instagram.com/hphotos-ak-xpa1/10809812_314522248740311_1728815139_n.jpg" }
    ];
}

- (void)loadCards {
    [self.frontCardView removeFromSuperview];
    [self.backCardView removeFromSuperview];
    
    // Display the first SlocanPhotoView in front. Users can swipe to indicate
    // whether they like or dislike the photo displayed.
    self.frontCardView = [self popPhotoViewWithFrame:[self frontCardViewFrame]];
    [self.view addSubview:self.frontCardView];
    
    // Display the second SlocanPhotoView in back. This view controller uses
    // the MDCSwipeToChooseDelegate protocol methods to update the front and
    // back views after each user swipe.
    self.backCardView = [self popPhotoViewWithFrame:[self backCardViewFrame]];
    [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
    
    // Add buttons to programmatically swipe the view left or right.
    // See the `nopeFrontCardView` and `likeFrontCardView` methods.
    if (self.nopeButton == nil) {
        self.nopeButton = [self constructNopeButton];
    }
    
    if (self.informationButton == nil) {
        self.informationButton = [self constructInformationButton];
        self.informationButton.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, self.nopeButton.center.y);
    }
    
    if (self.likeButton == nil) {
        self.likeButton = [self constructLikedButton];
    }
}

- (void)setFrontCardView:(SlocanPhotoView *)frontCardView {
    // Keep track of the photo currently being chosen.
    // Quick and dirty, just for the purposes of this sample app.
    _frontCardView = frontCardView;
    self.currentPhoto = frontCardView.photo;
}

- (SlocanPhotoView *)popPhotoViewWithFrame:(CGRect)frame {
    if ([self.photos count] == 0) {
        return nil;
    }

    // UIView+MDCSwipeToChoose and MDCSwipeToChooseView are heavily customizable.
    // Each take an "options" argument. Here, we specify the view controller as
    // a delegate, and provide a custom callback that moves the back card view
    // based on how far the user has panned the front card view.
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.threshold = 160.f;
    options.onPan = ^(MDCPanState *state){
        CGRect backCardViewFrame = [self backCardViewFrame];
        self.backCardView.frame = CGRectMake(backCardViewFrame.origin.x,
                                             backCardViewFrame.origin.y - (state.thresholdRatio * 10.f),
                                             CGRectGetWidth(backCardViewFrame),
                                             CGRectGetHeight(backCardViewFrame));
    };

    // Create a photoView with the top photo in the photos array, then pop
    // that photo off the stack.
    SlocanPhotoView *photoView = [[SlocanPhotoView alloc] initWithFrame:frame photo:self.photos[0] options:options];
    [self.photos removeObjectAtIndex:0];
    return photoView;
}

#pragma mark - View Construction

- (CGRect)frontCardViewFrame {
    CGFloat horizontalPadding = 20.f;
    CGFloat topPadding = 60.f;
    CGFloat bottomPadding = 200.f;
    return CGRectMake(horizontalPadding,
                      topPadding,
                      CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),
                      CGRectGetHeight(self.view.frame) - bottomPadding);
}

- (CGRect)backCardViewFrame {
    CGRect frontFrame = [self frontCardViewFrame];
    return CGRectMake(frontFrame.origin.x,
                      frontFrame.origin.y + 10.f,
                      CGRectGetWidth(frontFrame),
                      CGRectGetHeight(frontFrame));
}

// Create and add the "nope" button.
- (UIButton *)constructNopeButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"unlike"];
    UIImage *selectedImage = [UIImage imageNamed:@"unlike_selected"];
    button.frame = CGRectMake(ChoosePhotoButtonHorizontalPadding,
                              CGRectGetMaxY(self.backCardView.frame) + ChoosePhotoButtonVerticalPadding,
                              image.size.width,
                              image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateHighlighted];
    [button setImage:selectedImage forState:UIControlStateSelected];
    [button setTintColor:[UIColor colorWithRed:247.f/255.f
                                         green:91.f/255.f
                                          blue:37.f/255.f
                                         alpha:1.f]];
    [button addTarget:self
               action:@selector(nopeFrontCardView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}

- (UIButton *)constructInformationButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"info"];
    
    button.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(showInformation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}

// Create and add the "like" button.
- (UIButton *)constructLikedButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"like"];
    UIImage *selectedImage = [UIImage imageNamed:@"like_selected"];
    button.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - image.size.width - ChoosePhotoButtonHorizontalPadding,
                              CGRectGetMaxY(self.backCardView.frame) + ChoosePhotoButtonVerticalPadding,
                              image.size.width,
                              image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateHighlighted];
    [button setImage:selectedImage forState:UIControlStateSelected];
    [button setTintColor:[UIColor colorWithRed:29.f/255.f
                                         green:245.f/255.f
                                          blue:106.f/255.f
                                         alpha:1.f]];
    [button addTarget:self
               action:@selector(likeFrontCardView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}

#pragma mark - Control Events

- (void)showInformation {
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    visualEffectView.frame = self.view.bounds;
    [self.view addSubview:visualEffectView];
    self.visualEffectView = visualEffectView;
    
    PhotoDetailsViewController *photoDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:SLCMainStoryboardPhotoDetailsViewControllerIdentifier];
    photoDetailsViewController.delegate = self;
    photoDetailsViewController.photo = self.currentPhoto;
    photoDetailsViewController.view.alpha = 0.f;
    
    [self addChildViewController:photoDetailsViewController];
    [self.visualEffectView addSubview:photoDetailsViewController.view];
    
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        photoDetailsViewController.view.alpha = 1.f;
    } completion:^(BOOL finished) {
        [photoDetailsViewController didMoveToParentViewController:self];
    }];
}

- (void)photoDetailsViewDidClose {
    [self.visualEffectView removeFromSuperview];
    self.visualEffectView = nil;
}

// Programmatically "nopes" the front card view.
- (void)nopeFrontCardView {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionLeft];
}

// Programmatically "likes" the front card view.
- (void)likeFrontCardView {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionRight];
}

#pragma mark - Signup delegate

- (void)didSignupFrom:(id)from {
    [self fetchPhotosAtPage:1];
    
    [self.signUpNavigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MDCSwipeToChooseDelegate Protocol Methods

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"You couldn't decide on %@.", self.currentPhoto[@"url"]);
}

// This is called then a user swipes the view fully left or right.
- (void)view:(SlocanPhotoView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    // MDCSwipeToChooseView shows "NOPE" on swipes to the left,
    // and "LIKED" on swipes to the right.
    if (direction == MDCSwipeDirectionLeft) {
        NSLog(@"You noped %@.", self.currentPhoto[@"url"]);
        
        [self.nopeButton setHighlighted:YES];
        [self votePhotoWithID:[self.currentPhoto[@"id"] integerValue] asLiked:NO];
    } else {
        NSLog(@"You liked %@.", self.currentPhoto[@"url"]);
        
        [self.likeButton setHighlighted:YES];
        [self votePhotoWithID:[self.currentPhoto[@"id"] integerValue] asLiked:YES];
    }

    // MDCSwipeToChooseView removes the view from the view hierarchy
    // after it is swiped (this behavior can be customized via the
    // MDCSwipeOptions class). Since the front card view is gone, we
    // move the back card to the front, and create a new back card.
    self.frontCardView = self.backCardView;
    if ((self.backCardView = [self popPhotoViewWithFrame:[self backCardViewFrame]])) {
        // Fade the back card into view.
        self.backCardView.alpha = 0.f;
        [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.backCardView.alpha = 1.f;
                         } completion:^(BOOL finished) {
                             [self.nopeButton setHighlighted:NO];
                             [self.likeButton setHighlighted:NO];
                         }];
    }
    
    // Load next page.
    if (self.frontCardView == nil && self.backCardView == nil && [self.photos count] == 0) {
        [self fetchPhotosAtPage:self.currentPage+1];
    }
}


@end
