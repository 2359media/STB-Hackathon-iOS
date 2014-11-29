//
//  ItinerariesViewController.m
//  Slocan
//
//  Created by Hu Junfeng on 29/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import "ItinerariesViewController.h"
#import "ItineraryDetailViewController.h"
#import "Itinerary.h"
#import "Location.h"

@interface ItinerariesViewController ()

@property (nonatomic) NSArray *itineraries;

@end

@implementation ItinerariesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createFakeData];
}

- (void)createFakeData {
    NSMutableArray *itineraries = [NSMutableArray array];
    
    for (NSInteger idx = 0; idx < 5; idx++) {
        Itinerary *it = [[Itinerary alloc] init];
        it.itineraryName = [NSString stringWithFormat:@"Itinerary %ld", idx + 1];
        
        NSMutableArray *days = [NSMutableArray array];
        for (NSInteger dayIdx = 0; dayIdx < 5; dayIdx++) {
            
            ItineraryDay *aDay = [[ItineraryDay alloc] init];
            
            NSMutableArray *locations = [NSMutableArray array];
            
            Location *morningLocation = [[Location alloc] init];
            morningLocation.locationName = @"Morning Location";
            morningLocation.averageTimeSpent = @3;
            morningLocation.bestTimeToGo = SLCTimeToGoMorning;
            [locations addObject:morningLocation];
            
            Location *afternoonLocation = [[Location alloc] init];
            afternoonLocation.locationName = @"Afternoon Location";
            afternoonLocation.averageTimeSpent = @3;
            afternoonLocation.bestTimeToGo = SLCTimeToGoAfternoon;
            [locations addObject:afternoonLocation];
            
            Location *eveningLocation = [[Location alloc] init];
            eveningLocation.locationName = @"Evening Location";
            eveningLocation.averageTimeSpent = @3;
            eveningLocation.bestTimeToGo = SLCTimeToGoEvening;
            [locations addObject:eveningLocation];

            aDay.locations = [locations copy];
            [days addObject:aDay];
        }
        it.days = [days copy];
        [itineraries addObject:it];
    }
    
    self.itineraries = [itineraries copy];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger)[self.itineraries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SLCMainStoryboardItineraryCellIdentifier forIndexPath:indexPath];
    
    Itinerary *itinerary = self.itineraries[(NSUInteger)indexPath.row];
    cell.textLabel.text = itinerary.itineraryName;
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SLCMainStoryboardShowItineraryDetailIdentifier]) {
        ItineraryDetailViewController *itineraryDetailViewController = segue.destinationViewController;
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForCell:sender];
        itineraryDetailViewController.itinerary = self.itineraries[(NSUInteger)selectedIndexPath.row];
    }
}

@end
