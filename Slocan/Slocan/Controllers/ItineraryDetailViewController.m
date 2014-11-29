//
//  ItineraryDetailViewController.m
//  Slocan
//
//  Created by Hu Junfeng on 29/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import "ItineraryDetailViewController.h"
#import "Itinerary.h"
#import "Location.h"

@interface ItineraryDetailViewController ()

@end

@implementation ItineraryDetailViewController

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell" forIndexPath:indexPath];
    
    ItineraryDay *day = self.itinerary.days[(NSUInteger)indexPath.section];
    Location *location = day.locations[(NSUInteger)indexPath.row];
    
    cell.textLabel.text = location.locationName;
    NSString *locationTimeDescription = [NSString stringWithFormat:@"Avg Time Spent: %@ hrs; Best Time To Go: %@", location.averageTimeSpent, NSStringFromSLCTimeToGo(location.bestTimeToGo)];
    cell.detailTextLabel.text = locationTimeDescription;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Day %ld", section + 1];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
