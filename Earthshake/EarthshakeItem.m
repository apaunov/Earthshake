//
//  EarthshakeItem.m
//  Earthshake
//
//  Created by Andrey Paunov on 2016-03-24.
//  Copyright © 2016 Andrey Paunov. All rights reserved.
//

#import "EarthshakeItem.h"

#define kPlace          @"place"
#define kMagnitude      @"mag"
#define kTime           @"time"
#define kTimeZone       @"tz"
#define kFeatureType    @"type"
#define kCoordinates    @"coordinates"

@implementation EarthshakeItem

// TODO: REFACTOR THE FORMATTERS TO IMPROVE PERFORMENCE

- (NSString *)place
{
    NSString *place = [self.properties objectForKey:kPlace];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^(\\d*\\s*(km)\\s*[NSEW]*\\s*(of)\\s*)" options:0 error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:place options:0 range:NSMakeRange(0, place.length)];
    NSRange range = [match rangeAtIndex:1];
    NSString *placeTrim = place;

    if (range.length)
    {
        placeTrim = [place substringFromIndex:range.location + range.length];
    }

    return placeTrim;
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

- (CLLocationCoordinate2D)epicenter
{
    NSArray *coordinates = [self.geometry objectForKey:kCoordinates];

    CLLocationCoordinate2D epicenter = CLLocationCoordinate2DMake([[coordinates objectAtIndex:1] doubleValue], [[coordinates objectAtIndex:0] doubleValue]);

    return epicenter;
}

@end