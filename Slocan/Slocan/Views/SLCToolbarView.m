//
//  SLCButtonView.m
//  Slocan
//
//  Created by Jesse Armand on 29/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import "SLCToolbarView.h"

@interface SLCToolbarView ()

@property (weak, nonatomic) IBOutlet UIButton *nopeButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@end

@implementation SLCToolbarView

- (void)awakeFromNib {
    [self.nopeButton addTarget:self action:@selector(nope:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self.likeButton addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)nope:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(toolbarViewDidNoped:)]) {
        [self.delegate toolbarViewDidNoped:self];
    }
}

- (void)close:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(toolbarViewDidClose:)]) {
        [self.delegate toolbarViewDidClose:self];
    }
}

- (void)like:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(toolbarViewDidLiked:)]) {
        [self.delegate toolbarViewDidLiked:self];
    }
}

@end
