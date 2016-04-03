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
#define kTime @"time"
#define kTimeZone @"tz"
#define kFeatureType @"type"

@implementation EarthshakeItem


// TO DO: REFACTOR THE FORMATTERS TO IMPROVE PERFORMENCE

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

- (NSString *)date
{
    double totalSeconds = [[self.properties objectForKey:kTime] doubleValue];
    int timeZoneSeconds = [[self.properties objectForKey:kTimeZone] intValue] * 60;

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(totalSeconds / 1000)];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:timeZoneSeconds]];
    [dateFormatter setDateFormat:@"yyyy'/'MM'/'dd"];

    NSString *formattedDate = [dateFormatter stringFromDate:date];

    return formattedDate;
}

- (NSString *)time
{
    double totalSeconds = [[self.properties objectForKey:kTime] doubleValue];
    int timeZoneSeconds = [[self.properties objectForKey:kTimeZone] intValue] * 60;

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(totalSeconds / 1000)];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:timeZoneSeconds]];
    [dateFormatter setDateFormat:@"h':'mm a"];

    NSString *formattedDate = [dateFormatter stringFromDate:date];

    return formattedDate;
}

- (NSString *)featureType
{
    NSString *type = [self.properties objectForKey:kFeatureType];
    return [type capitalizedString];
}

@end
