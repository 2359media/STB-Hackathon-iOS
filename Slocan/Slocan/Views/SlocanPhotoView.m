//
//  SlocanPhotoView.m
//  Slocan
//
//  Created by Jesse Armand on 29/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import "SlocanPhotoView.h"

#import "UIView+SLCLabel.h"

#import <AFNetworking/UIImageView+AFNetworking.h>

static CGFloat const SLCSwipeToChooseViewHorizontalPadding = 10.f;
static CGFloat const SLCSwipeToChooseViewTopPadding = 20.f;
static CGFloat const SLCSwipeToChooseViewLabelWidth = 65.f;

@interface SlocanPhotoView ()

@property (nonatomic, strong) UIView *infoOverlay;
@property (nonatomic, strong) UILabel *venueLabel;
@property (nonatomic, strong) UILabel *venueTipLabel;

@property (nonatomic, strong) UIView *ratingOverlay;
@property (nonatomic, strong) UILabel *ratingLabel;
@property (nonatomic, strong) UILabel *likesLabel;

@property (nonatomic, strong) UIView *categoryOverlay;
@property (nonatomic, strong) UILabel *categoryLabel;

@end

@implementation SlocanPhotoView

- (instancetype)initWithFrame:(CGRect)frame
                        photo:(NSDictionary *)photo
                      options:(MDCSwipeToChooseViewOptions *)options
{
    self = [super initWithFrame:frame options:options];
    if (self) {
        _photo = photo;
        
        NSString *photoURLString = [_photo valueForKey:@"url"];
        [self.imageView setImageWithURL:[NSURL URLWithString:photoURLString] placeholderImage:nil];

        self.autoresizingMask = UIViewAutoresizingFlexibleHeight |
                                UIViewAutoresizingFlexibleWidth |
                                UIViewAutoresizingFlexibleBottomMargin;
        self.imageView.autoresizingMask = self.autoresizingMask;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        CGFloat height = 64.f;
        self.infoOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - height, CGRectGetWidth(frame), height)];
        self.infoOverlay.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.6];
        
        CGFloat width = 64.f;
        self.ratingOverlay = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.infoOverlay.frame) - width, 0, width, height)];
        self.ratingOverlay.backgroundColor = [UIColor colorWithHexString:@"#29bdba" alpha:0.6];
        
        self.ratingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, CGRectGetWidth(self.ratingOverlay.frame), 24.f)];
        self.ratingLabel.textAlignment = NSTextAlignmentCenter;
        self.ratingLabel.font = [UIFont appLightFontOfSize:24];
        self.ratingLabel.textColor = [UIColor whiteColor];
        
        float rating = [[self.photo valueForKeyPath:@"venue.rating"] floatValue];
        self.ratingLabel.text = [@(rating) stringValue];
        
        self.likesLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, CGRectGetMaxY(self.ratingLabel.frame) + 4, CGRectGetWidth(self.ratingOverlay.frame) - 8, 20.f)];
        self.likesLabel.textAlignment = NSTextAlignmentCenter;
        self.likesLabel.font = [UIFont appBookFontOfSize:12];
        self.likesLabel.textColor = [UIColor whiteColor];
        
        NSNumber *likes = [self.photo valueForKey:@"counter_like"];
        self.likesLabel.text = [NSString stringWithFormat:NSLocalizedString(@"/ %@ likes", nil), likes];
        
        [self.ratingOverlay addSubview:self.ratingLabel];
        [self.ratingOverlay addSubview:self.likesLabel];
        [self.infoOverlay addSubview:self.ratingOverlay];
        
        self.venueLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, CGRectGetWidth(self.infoOverlay.frame) - CGRectGetWidth(self.ratingOverlay.frame) - 16, 24.f)];
        self.venueLabel.textColor = [UIColor whiteColor];
        self.venueLabel.font = [UIFont appLightFontOfSize:24];
        self.venueLabel.text = [self.photo valueForKeyPath:@"venue.name"];

        self.venueTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(self.venueLabel.frame) + 4, CGRectGetWidth(self.venueLabel.frame) - 16, 20.f)];
        self.venueTipLabel.textColor = [UIColor whiteColor];
        self.venueTipLabel.font = [UIFont appBookFontOfSize:12];
        self.venueTipLabel.text = [self.photo valueForKeyPath:@"venue.tip"];
        
        [self.infoOverlay addSubview:self.venueLabel];
        [self.infoOverlay addSubview:self.venueTipLabel];
        [self addSubview:self.infoOverlay];

        NSString *category = [[self.photo valueForKeyPath:@"venue.tags"] firstObject];
        CGSize textSize = [category sizeWithAttributes:@{ NSFontAttributeName: [UIFont appBookFontOfSize:12], NSForegroundColorAttributeName: [UIColor whiteColor] }];
        
        self.categoryOverlay = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMinY(self.infoOverlay.frame) - height, textSize.width + 8, textSize.height + 8)];
        self.categoryOverlay.backgroundColor = self.infoOverlay.backgroundColor;
        
        self.categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, CGRectGetWidth(self.categoryOverlay.frame) - 4, textSize.height + 4)];
        self.categoryLabel.textColor = [UIColor whiteColor];
        self.categoryLabel.font = [UIFont appBookFontOfSize:12];
        self.categoryLabel.text = category;
        [self.categoryOverlay addSubview:self.categoryLabel];
        [self addSubview:self.categoryOverlay];
    }
    return self;
}

- (void)constructLikedView {
    CGRect frame = CGRectMake(SLCSwipeToChooseViewHorizontalPadding,
                              SLCSwipeToChooseViewTopPadding,
                              CGRectGetMidX(self.imageView.bounds),
                              SLCSwipeToChooseViewLabelWidth);
    self.likedView = [[UIView alloc] initWithFrame:frame];
    [self.likedView slc_constructLabelWithText:NSLocalizedString(@"Like", nil)
                                                 color:[UIColor colorWithHexString:@"#46dedb"]
                                                 angle:-15.f];
    self.likedView.alpha = 0.f;
    [self.imageView addSubview:self.likedView];
}

- (void)constructNopeImageView {
    CGFloat width = CGRectGetMidX(self.imageView.bounds);
    CGFloat xOrigin = CGRectGetMaxX(self.imageView.bounds) - width - SLCSwipeToChooseViewHorizontalPadding;
    self.nopeView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin,
                                                                  SLCSwipeToChooseViewTopPadding,
                                                                  width,
                                                                  SLCSwipeToChooseViewLabelWidth)];
    [self.nopeView slc_constructLabelWithText:NSLocalizedString(@"Nope", nil)
                                                color:[UIColor colorWithHexString:@"#e63b3f"]
                                                angle:-15.f];
    self.nopeView.alpha = 0.f;
    [self.imageView addSubview:self.nopeView];
}

@end
