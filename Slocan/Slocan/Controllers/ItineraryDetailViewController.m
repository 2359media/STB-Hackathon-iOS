//
//  ItineraryDetailViewController.m
//  Slocan
//
//  Created by Hu Junfeng on 29/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import "ItineraryDetailViewController.h"
#import "ItineraryDetailTableViewController.h"
#import "ItineraryDetailMapViewController.h"

@interface ItineraryDetailViewController ()

@property (nonatomic, weak) IBOutlet UIView *containerView;

@property (nonatomic) ItineraryDetailTableViewController *tableViewController;
@property (nonatomic) ItineraryDetailMapViewController *mapViewController;

@end

@implementation ItineraryDetailViewController

- (ItineraryDetailMapViewController *)mapViewController {
    if (!_mapViewController) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:SLCMainStoryboardName bundle:nil];
        _mapViewController = [mainStoryboard instantiateViewControllerWithIdentifier:SLCMainStoryboardItineraryDetailMapViewControllerIdentifier];
        _mapViewController.itinerary = self.itinerary;
    }
    return _mapViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.itinerary.itineraryName;
}

- (IBAction)switchView:(UIBarButtonItem *)sender {
    if (sender.tag == 0) {
        sender.title = NSLocalizedString(@"Table", nil);
        sender.image = nil;
        [self showMapViewController];
        sender.tag = 1;
    }
    else if (sender.tag == 1) {
        sender.title = nil;
        sender.image = [UIImage imageNamed:@"Map"];
        [self showTableViewController];
        sender.tag = 0;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SLCMainStoryboardEmbedItineraryTableIdentifier]) {
        ItineraryDetailTableViewController *tableViewController = segue.destinationViewController;
        tableViewController.itinerary = self.itinerary;
        self.tableViewController = tableViewController;
    }
}

- (void)showMapViewController {
    [self switchFromViewController:self.tableViewController toViewController:self.mapViewController];
}

- (void)showTableViewController {
    [self switchFromViewController:self.mapViewController toViewController:self.tableViewController];
}

- (void)switchFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController {
    // Remove fromViewController
    [fromViewController willMoveToParentViewController:nil];
    [fromViewController.view removeFromSuperview];
    [fromViewController removeFromParentViewController];
    
    // Add toViewController
    [self addChildViewController:toViewController];
    toViewController.view.frame = self.containerView.bounds;
    [self.containerView addSubview:toViewController.view];
    [toViewController didMoveToParentViewController:self];
}

@end
