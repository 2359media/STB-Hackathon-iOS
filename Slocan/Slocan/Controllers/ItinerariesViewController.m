//
//  ItinerariesViewController.m
//  Slocan
//
//  Created by Hu Junfeng on 29/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import "ItinerariesViewController.h"
#import "ItineraryDetailTableViewController.h"
#import "Itinerary.h"
#import "Location.h"

@interface ItinerariesViewController ()

@property (nonatomic) NSMutableArray *itineraries;

@end

@implementation ItinerariesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createFakeData];
    
    // Add new schedule button
    UIButton *addScheduleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addScheduleButton addTarget:self action:@selector(createNewItinerary:) forControlEvents:UIControlEventTouchUpInside];
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName: [UIColor colorWithHexValue:0xb3b3b3],
        NSFontAttributeName: [UIFont appBookFontOfSize:16],
    };
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Add Schedule", nil) attributes:attributes];
    [addScheduleButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    [addScheduleButton sizeToFit];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addScheduleButton];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)createFakeData {
    NSMutableArray *itineraries = [NSMutableArray array];
    
    for (NSInteger idx = 0; idx < 5; idx++) {
        [itineraries addObject:[self fakeItinerary]];
    }
    
    self.itineraries = itineraries;
}

- (Itinerary *)fakeItinerary {
    static NSInteger count = 0;
    
    Itinerary *it = [[Itinerary alloc] init];
    it.itineraryName = [NSString stringWithFormat:@"Itinerary %ld", ++count];
    
    NSMutableArray *days = [NSMutableArray array];
    for (NSInteger dayIdx = 0; dayIdx < 5; dayIdx++) {
        
        ItineraryDay *aDay = [[ItineraryDay alloc] init];
        
        NSMutableArray *locations = [NSMutableArray array];
        
        Location *morningLocation = [[Location alloc] init];
        morningLocation.locationName = @"Morning Location";
        morningLocation.averageTimeSpent = @3;
        morningLocation.bestTimeToGo = SLCTimeToGoMorning;
        morningLocation.latitude = @(1.402070 + 0.01*dayIdx);
        morningLocation.longitude = @(103.760827 + 0.01*dayIdx);
        [locations addObject:morningLocation];
        
        Location *afternoonLocation = [[Location alloc] init];
        afternoonLocation.locationName = @"Afternoon Location";
        afternoonLocation.averageTimeSpent = @3;
        afternoonLocation.bestTimeToGo = SLCTimeToGoAfternoon;
        afternoonLocation.latitude = @(1.388341 + 0.01*dayIdx);
        afternoonLocation.longitude = @(103.793100 + 0.01*dayIdx);
        [locations addObject:afternoonLocation];
        
        Location *eveningLocation = [[Location alloc] init];
        eveningLocation.locationName = @"Evening Location";
        eveningLocation.averageTimeSpent = @3;
        eveningLocation.bestTimeToGo = SLCTimeToGoEvening;
        eveningLocation.latitude = @(1.311458 + 0.01*dayIdx);
        eveningLocation.longitude = @(103.830522 + 0.01*dayIdx);
        [locations addObject:eveningLocation];
        
        aDay.locations = [locations copy];
        [days addObject:aDay];
    }
    it.days = [days copy];
    return it;
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
        ItineraryDetailTableViewController *itineraryDetailViewController = segue.destinationViewController;
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForCell:sender];
        itineraryDetailViewController.itinerary = self.itineraries[(NSUInteger)selectedIndexPath.row];
    }
    else if ([segue.identifier isEqualToString:SLCMainStoryboardCreateNewItineraryIdentifier]) {
        ItineraryDetailTableViewController *itineraryDetailViewController = segue.destinationViewController;
        itineraryDetailViewController.itinerary = sender;
    }
}

#pragma mark - Actions

- (IBAction)createNewItinerary:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Choose A Duration", nil) 
                                                                             message:NSLocalizedString(@"How long would you plan for your next itinerary?", nil)
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    
    NSArray *allDurations = @[ @(SLCItineraryDurationHalfDay), @(SLCItineraryDurationOneDay), @(SLCItineraryDurationThreeDays) ];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"Name", nil);
    }];
    
    for (NSNumber *aDuration in allDurations) {
        SLCItineraryDuration duration = [aDuration unsignedIntegerValue];
        NSString *durationDescription = NSStringFromItineraryDuration(duration);
        
        [alertController addAction:[UIAlertAction actionWithTitle:durationDescription style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

            UITextField *nameTextField = [alertController.textFields firstObject];
            
            // TODO: Request the server for a new itinerary
            Itinerary *newItinerary = [self fakeItinerary];
            newItinerary.itineraryName = nameTextField.text;
            [self.itineraries addObject:newItinerary];
            [self.tableView reloadData];
            [self performSegueWithIdentifier:SLCMainStoryboardCreateNewItineraryIdentifier sender:newItinerary];
            
        }]];
    }
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
