//
//  SlocanPhotoView.h
//  Slocan
//
//  Created by Jesse Armand on 29/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import "MDCSwipeToChooseView.h"

@interface SlocanPhotoView : MDCSwipeToChooseView

@property (copy, nonatomic) NSDictionary *photo;

- (instancetype)initWithFrame:(CGRect)frame
                        photo:(NSDictionary *)photo
                      options:(MDCSwipeToChooseViewOptions *)options;

@end
