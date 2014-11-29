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
#import <UIColor-HTMLColors/UIColor+HTMLColors.h>

static CGFloat const SLCSwipeToChooseViewHorizontalPadding = 10.f;
static CGFloat const SLCSwipeToChooseViewTopPadding = 20.f;
static CGFloat const SLCSwipeToChooseViewLabelWidth = 65.f;

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
