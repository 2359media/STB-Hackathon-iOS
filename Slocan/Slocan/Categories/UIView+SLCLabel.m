//
//  UIView+SLCBorderedLabel.m
//  Slocan
//
//  Created by Jesse Armand on 30/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import "UIView+SLCLabel.h"

@implementation UIView (SLCLabel)

- (void)slc_constructLabelWithText:(NSString *)text
                             color:(UIColor *)color
                             angle:(CGFloat)angle {
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    label.text = [text uppercaseString];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Bender-Inline"
                                 size:45.f];
    label.textColor = color;
    [self addSubview:label];

    self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, (angle * (M_PI/180.0)));
}

@end
