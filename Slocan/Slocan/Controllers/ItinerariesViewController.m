//
//  ItinerariesViewController.m
//  Slocan
//
//  Created by Hu Junfeng on 29/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import "ItinerariesViewController.h"
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
        [itineraries addObject:it];
    }
    
    self.itineraries = [itineraries copy];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger)[self.itineraries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItineraryCell" forIndexPath:indexPath];
    
    Itinerary *itinerary = self.itineraries[(NSUInteger)indexPath.row];
    cell.textLabel.text = itinerary.itineraryName;
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //
}

@end
