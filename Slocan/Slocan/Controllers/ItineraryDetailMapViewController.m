//
//  ItineraryDetailMapViewController.m
//  Slocan
//
//  Created by Hu Junfeng on 29/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

@import MapKit;

#import "ItineraryDetailMapViewController.h"
#import "Location.h"

@interface ItineraryDetailMapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ItineraryDetailMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *annotations = [NSMutableArray array];
    for (ItineraryDay *anItineraryDay in self.itinerary.days) {
        for (Location *aLocation in anItineraryDay.locations) {
            [annotations addObject:aLocation];
        }
    }
    [self.mapView addAnnotations:annotations];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
 
#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView* aView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MyCustomAnnotation"];
    return aView;
}

@end
