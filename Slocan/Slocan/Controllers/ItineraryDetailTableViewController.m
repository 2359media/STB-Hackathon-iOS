//
//  ItineraryDetailTableViewController.m
//  Slocan
//
//  Created by Hu Junfeng on 29/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import "ItineraryDetailTableViewController.h"
#import "Itinerary.h"
#import "Location.h"
#import "SLCLocationCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface ItineraryDetailTableViewController ()

@end

@implementation ItineraryDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (NSInteger)[self.itinerary.days count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ItineraryDay *day = self.itinerary.days[(NSUInteger)section];
    return (NSInteger)[day.locations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SLCLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:SLCMainStoryboardLocationCellIdentifier forIndexPath:indexPath];
    
    ItineraryDay *day = self.itinerary.days[(NSUInteger)indexPath.section];
    Location *location = day.locations[(NSUInteger)indexPath.row];
    
    cell.locationNameLabel.text = location.locationName;
    cell.bestTimeToGoLabel.text = [location subtitle];
    cell.avgTimeSpentLabel.text = [NSString stringWithFormat:@"%@ hrs", location.averageTimeSpent];
    [cell.thumbnailView setImageWithURL:location.photoURL placeholderImage:[UIImage imageNamed:@"img_shop"]];
    
    // Set background color
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    cell.backgroundView = backgroundView;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)];
    view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 50, 20)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont appBookFontOfSize:12];
    label.text = [NSString stringWithFormat:@"Day %ld", section + 1];
    label.backgroundColor = [UIColor clearColor];
    
    [view addSubview:label];
    return view;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
