//
//  EarthshakeItem.h
//  Earthshake
//
//  Created by Andrey Paunov on 2016-03-24.
//  Copyright © 2016 Andrey Paunov. All rights reserved.

//  API Documentation: http://earthquake.usgs.gov/fdsnws/event/1/

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface EarthshakeItem : NSObject

@property (strong, nonatomic) NSString *featureType;
@property (strong, nonatomic) NSDictionary *properties;
@property (strong, nonatomic) NSDictionary *geometry;
@property (strong, nonatomic) NSString *earthshakeId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *place;
@property (strong, nonatomic) NSNumber *magnitude;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *detailURLString;
@property (assign, nonatomic) CLLocationCoordinate2D epicenter;
@property (strong, nonatomic) NSNumber *tsunami;

- (BOOL)isEarthquake;
- (BOOL)isQuarry;

@end
