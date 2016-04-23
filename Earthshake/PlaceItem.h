//
//  Place.h
//  Earthshake
//
//  Created by Andrey Paunov on 2016-04-09.
//  Copyright © 2016 AP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PlaceItem : NSObject <MKAnnotation>

@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

@end