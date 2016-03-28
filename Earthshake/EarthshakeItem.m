//
//  EarthshakeItem.m
//  Earthshake
//
//  Created by Andrey Paunov on 2016-03-24.
//  Copyright © 2016 Andrey Paunov. All rights reserved.
//

#import "EarthshakeItem.h"

#define kTitle @"title"
#define kPlace @"place"
#define kMagnitude @"mag"

@implementation EarthshakeItem

- (NSString *)title
{
    NSString *title = [self.properties objectForKey:kTitle];
    return title;
}

- (NSString *)place
{
    NSString *place = [self.properties objectForKey:kPlace];
    return place;
}

- (NSNumber *)magnitude
{
    NSNumber *magnitude = [NSNumber numberWithDouble:[[self.properties objectForKey:kMagnitude] doubleValue]];
    return magnitude;
}

@end
