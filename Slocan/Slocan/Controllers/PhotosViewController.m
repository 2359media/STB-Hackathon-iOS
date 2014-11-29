//
//  PhotosViewController.m
//  Slocan
//
//  Created by Jesse Armand on 29/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import "PhotosViewController.h"
#import "RegisterViewController.h"

#import <MDCSwipeToChoose/MDCSwipeToChoose.h>

#import "SlocanPhotoView.h"

static const CGFloat ChoosePhotoButtonHorizontalPadding = 80.f;
static const CGFloat ChoosePhotoButtonVerticalPadding = 20.f;

@interface PhotosViewController () <SignupDelegate, MDCSwipeToChooseDelegate>

@property (nonatomic, copy) NSDictionary *currentPhoto;
@property (nonatomic, strong) SlocanPhotoView *frontCardView;
@property (nonatomic, strong) SlocanPhotoView *backCardView;

@property (nonatomic, strong) NSMutableArray *photos;

@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photos = [[self defaultPhotos] mutableCopy];
    
    // Display the first ChoosePersonView in front. Users can swipe to indicate
    // whether they like or dislike the person displayed.
    self.frontCardView = [self popPhotoViewWithFrame:[self frontCardViewFrame]];
    [self.view addSubview:self.frontCardView];

    // Display the second ChoosePersonView in back. This view controller uses
    // the MDCSwipeToChooseDelegate protocol methods to update the front and
    // back views after each user swipe.
    self.backCardView = [self popPhotoViewWithFrame:[self backCardViewFrame]];
    [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];

    // Add buttons to programmatically swipe the view left or right.
    // See the `nopeFrontCardView` and `likeFrontCardView` methods.
    [self constructNopeButton];
    [self constructLikedButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:SlocanAccessToken];
    if ([accessToken length] == 0) {
        [self showSignUp];
    }
}

- (void)showSignUp {
    RegisterViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"registerViewController"];
    viewController.delegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Internal Methods

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

- (void)setFrontCardView:(SlocanPhotoView *)frontCardView {
    // Keep track of the person currently being chosen.
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

    // Create a personView with the top person in the people array, then pop
    // that person off the stack.
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
- (void)constructNopeButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"nope"];
    button.frame = CGRectMake(ChoosePhotoButtonHorizontalPadding,
                              CGRectGetMaxY(self.backCardView.frame) + ChoosePhotoButtonVerticalPadding,
                              image.size.width,
                              image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button setTintColor:[UIColor colorWithRed:247.f/255.f
                                         green:91.f/255.f
                                          blue:37.f/255.f
                                         alpha:1.f]];
    [button addTarget:self
               action:@selector(nopeFrontCardView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

// Create and add the "like" button.
- (void)constructLikedButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"liked"];
    button.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - image.size.width - ChoosePhotoButtonHorizontalPadding,
                              CGRectGetMaxY(self.backCardView.frame) + ChoosePhotoButtonVerticalPadding,
                              image.size.width,
                              image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button setTintColor:[UIColor colorWithRed:29.f/255.f
                                         green:245.f/255.f
                                          blue:106.f/255.f
                                         alpha:1.f]];
    [button addTarget:self
               action:@selector(likeFrontCardView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark Control Events

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
    
}

#pragma mark - MDCSwipeToChooseDelegate Protocol Methods

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"You couldn't decide on %@.", self.currentPhoto[@"url"]);
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    // MDCSwipeToChooseView shows "NOPE" on swipes to the left,
    // and "LIKED" on swipes to the right.
    if (direction == MDCSwipeDirectionLeft) {
        NSLog(@"You noped %@.", self.currentPhoto[@"url"]);
    } else {
        NSLog(@"You liked %@.", self.currentPhoto[@"url"]);
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
                         } completion:nil];
    }
}


@end
