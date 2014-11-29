//
//  SlocanPhotoView.m
//  Slocan
//
//  Created by Jesse Armand on 29/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import "SlocanPhotoView.h"

#import <AFNetworking/UIImageView+AFNetworking.h>

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


@end
