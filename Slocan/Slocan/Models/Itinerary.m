//
//  Itinerary.m
//  Slocan
//
//  Created by Hu Junfeng on 29/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import "Itinerary.h"
#import "Location.h"

@implementation Itinerary

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _itineraryID = dict[@"id"];
        _itineraryName = dict[@"name"];
        
        NSMutableArray *days = [NSMutableArray array];
        for (NSDictionary *dayDict in dict[@"data"]) {
            ItineraryDay *aDay = [[ItineraryDay alloc] initWithDictionary:dayDict];
            [days addObject:aDay];
        }
        
        _days = [days copy];
    }
    return self;
}

@end

@implementation ItineraryDay

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        NSMutableArray *locations = [NSMutableArray array];
        NSArray *timeslots = @[ @"whole_day", @"morning", @"afternoon", @"evening" ];
        for (NSString *oneSlot in timeslots) {
            NSArray *locationDicts = dict[oneSlot][@"venues"];
            for (NSDictionary *locationDict in locationDicts) {
                Location *location = [[Location alloc] initWithDictionary:locationDict];
                [locations addObject:location];
            }
        }
        _locations = [locations copy];
    }
    return self;
}

@end

NSString *NSStringFromItineraryDuration(SLCItineraryDuration duration) {
    NSString *durationDescription = @"Unknown Duration Description";
    switch (duration) {
        case SLCItineraryDurationOneDay:
            durationDescription = NSLocalizedString(@"1 Day", nil);
            break;
        case SLCItineraryDurationThreeDays:
            durationDescription = NSLocalizedString(@"3 Days", nil);
            break;
        case SLCItineraryDurationFiveDays:
            durationDescription = NSLocalizedString(@"5 Days", nil);
            break;
        default:
            break;
    }
    return durationDescription;
}
