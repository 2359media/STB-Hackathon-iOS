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
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface ItinerariesViewController ()

@property (nonatomic) NSMutableArray *itineraries;

@end

@implementation ItinerariesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.itineraries = [NSMutableArray array];
    [self getAllItineraries];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{
        NSForegroundColorAttributeName: [UIColor whiteColor],
        NSFontAttributeName: [UIFont appBookFontOfSize:20],
    };
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(popViewControllerAnimated:)];
    
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
    
    // Remove seperators at the bottom of the table view
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger)[self.itineraries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SLCMainStoryboardItineraryCellIdentifier forIndexPath:indexPath];
    
    Itinerary *itinerary = self.itineraries[(NSUInteger)indexPath.row];
    cell.textLabel.text = itinerary.itineraryName;
    NSUInteger numberOfDays = [itinerary.days count];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld %@", numberOfDays, numberOfDays > 1 ? @"Days" : @"Day"];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    cell.backgroundView = backgroundView;

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

- (void)getAllItineraries {
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Getting all itineraries", nil)];
    NSInteger userId = [[NSUserDefaults standardUserDefaults] integerForKey:SlocanUserID];
    if (userId == 0) {
        userId = 1;
    }
    
    NSDictionary *parameters = @{ @"user_id": @(userId) };
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:SlocanBaseURL]];
    [sessionManager GET:@"api/v1/itineraries" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSArray *responseArray = responseObject;
            if ([responseArray count] > 0) {
                for (NSDictionary *dict in responseArray) {
                    Itinerary *itinerary = [[Itinerary alloc] initWithDictionary:dict];
                    [self.itineraries addObject:itinerary];
                }
                [self.tableView reloadData];
            }
        }
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        
        if (error) {
            NSLog(@"%@", error);
        }
        
    }];
}

- (IBAction)createNewItinerary:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Choose A Duration", nil) 
                                                                             message:NSLocalizedString(@"How long would you plan for your next itinerary?", nil)
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    
    NSArray *allDurations = @[ @(SLCItineraryDurationOneDay), @(SLCItineraryDurationThreeDays), @(SLCItineraryDurationFiveDays) ];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"Name", nil);
    }];
    
    for (NSNumber *aDuration in allDurations) {
        SLCItineraryDuration duration = [aDuration unsignedIntegerValue];
        NSString *durationDescription = NSStringFromItineraryDuration(duration);
        
        [alertController addAction:[UIAlertAction actionWithTitle:durationDescription style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

            UITextField *nameTextField = [alertController.textFields firstObject];
            NSString *name = nameTextField.text;
            
            [self requestNewItineraryWithDuration:duration success:^(Itinerary *itinerary) {
                if ([name length] > 0) {
                    itinerary.itineraryName = name;
                }
                
                [self.itineraries addObject:itinerary];
                [self.tableView reloadData];
                [self performSegueWithIdentifier:SLCMainStoryboardCreateNewItineraryIdentifier sender:itinerary];
                
            } failure:^(NSError *error) {
                //
            }];
            
        }]];
    }
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)requestNewItineraryWithDuration:(SLCItineraryDuration)duration
                                success:(void (^)(Itinerary *itinerary))success
                                failure:(void (^)(NSError *error))failure {
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Creating a new itinerary", nil)];
    NSInteger userId = [[NSUserDefaults standardUserDefaults] integerForKey:SlocanUserID];
    if (userId == 0) {
        userId = 1;
    }
    
    NSDictionary *parameters = @{ @"user_id": @(userId), @"duration": @(duration) };
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:SlocanBaseURL]];
    [sessionManager GET:@"api/v1/itineraries/query" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        
        NSLog(@"%@", responseObject);
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            Itinerary *itinerary = [[Itinerary alloc] initWithDictionary:responseObject];
            if (success) success(itinerary);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        
        if (error) {
            NSLog(@"%@", error);
        }
        
        if (failure) failure(error);
    }];
}

@end
