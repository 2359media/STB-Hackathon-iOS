//
//  UIView+SLCBorderedLabel.h
//  Slocan
//
//  Created by Jesse Armand on 30/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SLCLabel)

- (void)slc_constructLabelWithText:(NSString *)text
                             color:(UIColor *)color
                             angle:(CGFloat)angle;

@end
