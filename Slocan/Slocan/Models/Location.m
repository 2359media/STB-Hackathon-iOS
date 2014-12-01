//
//  Location.m
//  Slocan
//
//  Created by Hu Junfeng on 29/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import "Location.h"

@implementation Location

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _locationID = dict[@"id"];
        _locationName = dict[@"name"];
        _address = dict[@"address_blob"];
        _rating = dict[@"rating"];
        _tip = dict[@"tip"];
        _averageTimeSpent = dict[@"avg_time_spent"];
        _bestTimeToGoString = dict[@"best_time_for_visit"];
        _latitude = @([dict[@"latitude"] doubleValue]);
        _longitude = @([dict[@"longitude"] doubleValue]);
        _photoURL = [NSURL URLWithString:dict[@"photo"][@"url"]];
    }
    return self;
}

#pragma mark - MKAnnotation

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

- (NSString *)title {
    return self.locationName;
}

- (NSString *)subtitle {
    return [NSString stringWithFormat:@"Best time to go: %@", self.bestTimeToGoString];
}

@end

NSString *NSStringFromSLCTimeToGo(SLCTimeToGo timeToGo) {
    switch (timeToGo) {
        case SLCTimeToGoMorning:
            return @"Morning";
        case SLCTimeToGoAfternoon:
            return @"Afternoon";
        case SLCTimeToGoEvening:
            return @"Evening";
        default:
            return @"Unknown";
    }
}
