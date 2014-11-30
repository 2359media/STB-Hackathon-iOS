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

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

@interface ItineraryDay : NSObject

@property (nonatomic) NSArray *locations;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

typedef NS_ENUM(NSUInteger, SLCItineraryDuration) {
    SLCItineraryDurationOneDay = 1,
    SLCItineraryDurationThreeDays = 3,
    SLCItineraryDurationFiveDays = 5,
};

NSString *NSStringFromItineraryDuration(SLCItineraryDuration duration);
