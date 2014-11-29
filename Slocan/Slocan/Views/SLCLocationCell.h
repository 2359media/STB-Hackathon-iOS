//
//  SLCLocationCell.h
//  Slocan
//
//  Created by Hu Junfeng on 30/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLCLocationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *locationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestTimeToGoLabel;
@property (weak, nonatomic) IBOutlet UILabel *avgTimeSpentLabel;

@end
