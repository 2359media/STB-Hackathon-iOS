//
//  PhotoDetailsViewController.h
//  Slocan
//
//  Created by Jesse Armand on 29/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoDetailsViewDelegate <NSObject>

- (void)photoDetailsViewDidClose;

@end

@interface PhotoDetailsViewController : UIViewController

@property (nonatomic, copy) NSDictionary *photo;
@property (nonatomic, weak) id <PhotoDetailsViewDelegate> delegate;

@end
