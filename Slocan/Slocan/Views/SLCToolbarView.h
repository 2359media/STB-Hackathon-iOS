//
//  SLCButtonView.h
//  Slocan
//
//  Created by Jesse Armand on 29/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLCToolbarView;

@protocol SLCToolbarViewDelegate <NSObject>

- (void)toolbarViewDidNoped:(SLCToolbarView *)buttonView;
- (void)toolbarViewDidLiked:(SLCToolbarView *)buttonView;
- (void)toolbarViewDidClose:(SLCToolbarView *)buttonView;

@end

@interface SLCToolbarView : UIView

@property (weak, nonatomic) id<SLCToolbarViewDelegate> delegate;

@end
