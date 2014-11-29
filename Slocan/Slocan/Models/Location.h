//
//  Location.h
//  Slocan
//
//  Created by Hu Junfeng on 29/11/14.
//  Copyright (c) 2014 2359 Media Pte Ltd. All rights reserved.
//

@import Foundation;
@import CoreLocation;
@import MapKit;

typedef NS_ENUM(NSUInteger, SLCTimeToGo) {
    SLCTimeToGoMorning,
    SLCTimeToGoAfternoon,
    SLCTimeToGoEvening,
};

@interface Location : NSObject <MKAnnotation>

@property (nonatomic) NSNumber *locationID;
@property (nonatomic) NSString *locationName;
@property (nonatomic) NSNumber *rating;
@property (nonatomic) NSArray *images;
@property (nonatomic) NSNumber *averageTimeSpent;   // number of hoours
@property (nonatomic) SLCTimeToGo bestTimeToGo;
@property (nonatomic) NSNumber *latitude;
@property (nonatomic) NSNumber *longitude;

@end

NSString *NSStringFromSLCTimeToGo(SLCTimeToGo timeToGo);
