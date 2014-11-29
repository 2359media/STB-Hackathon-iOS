//
//  Itinerary.m
//  Slocan
//
//  Created by Hu Junfeng on 29/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import "Itinerary.h"

@implementation Itinerary

@end

@implementation ItineraryDay

@end

NSString *NSStringFromItineraryDuration(SLCItineraryDuration duration) {
    NSString *durationDescription = @"Unknown Duration Description";
    switch (duration) {
        case SLCItineraryDurationHalfDay:
            durationDescription = NSLocalizedString(@"Half Day", nil);
            break;
        case SLCItineraryDurationOneDay:
            durationDescription = NSLocalizedString(@"1 Day", nil);
            break;
        case SLCItineraryDurationThreeDays:
            durationDescription = NSLocalizedString(@"3 Days", nil);
            break;
        default:
            break;
    }
    return durationDescription;
}
