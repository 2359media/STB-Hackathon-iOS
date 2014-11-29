//
//  Location.m
//  Slocan
//
//  Created by Hu Junfeng on 29/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import "Location.h"

@implementation Location


#pragma mark - MKAnnotation

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

- (NSString *)title {
    return self.locationName;
}

- (NSString *)subtitle {
    return [NSString stringWithFormat:@"Avg Time Spent: %@ hrs; Best Time To Go: %@", self.averageTimeSpent, NSStringFromSLCTimeToGo(self.bestTimeToGo)];
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
