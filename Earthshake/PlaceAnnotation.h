//
//  Place.h
//  Earthshake
//
//  Created by Andrey Paunov on 2016-04-09.
//  Copyright © 2016 AP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PlaceAnnotation : NSObject <MKAnnotation>

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property (strong, nonatomic) NSNumber *magnitude;
@property (strong, nonatomic) NSString *detailURLString;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

@end