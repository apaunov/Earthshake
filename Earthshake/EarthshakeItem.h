//
//  EarthshakeItem.h
//  Earthshake
//
//  Created by Andrey Paunov on 2016-03-24.
//  Copyright © 2016 Andrey Paunov. All rights reserved.

//  API Documentation: http://earthquake.usgs.gov/fdsnws/event/1/

#import <Foundation/Foundation.h>

@interface EarthshakeItem : NSObject

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSDictionary *geometry;
@property (strong, nonatomic) NSDictionary *properties;
@property (strong, nonatomic) NSString *earthshakeId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *place;
@property (strong, nonatomic) NSNumber *magnitude;

@end
