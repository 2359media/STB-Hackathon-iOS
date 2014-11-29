//
//  SLCLocationCell.m
//  Slocan
//
//  Created by Hu Junfeng on 30/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

@import QuartzCore;

#import "SLCLocationCell.h"

@implementation SLCLocationCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.thumbnailView.layer.cornerRadius = self.thumbnailView.bounds.size.width / 2;
    self.thumbnailView.layer.masksToBounds = YES;
}

@end
