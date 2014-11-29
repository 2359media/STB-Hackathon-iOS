//
//  Itinerary.h
//  Slocan
//
//  Created by Hu Junfeng on 29/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ItineraryDay;

@interface Itinerary : NSObject

@property (nonatomic) NSNumber *itineraryID;
@property (nonatomic) NSString *itineraryName;
@property (nonatomic) NSArray *days;

@end

@interface ItineraryDay : NSObject

@property (nonatomic) NSArray *locations;

@end

typedef NS_ENUM(NSUInteger, SLCItineraryDuration) {
    SLCItineraryDurationHalfDay,
    SLCItineraryDurationOneDay,
    SLCItineraryDurationThreeDays,
};

NSString *NSStringFromItineraryDuration(SLCItineraryDuration duration);
