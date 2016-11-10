//
//  EarthshakeBaseViewController.h
//  Earthshake
//
//  Created by Andrey Paunov on 2016-04-24.
//  Copyright © 2016 AP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EarthshakeAppDelegate.h"
#import "EarthshakeService.h"

// Earthshake GeoJson Parameters
#define kStartTime @"starttime"
#define kEndTime @"endtime"
#define kMinMagnitude @"minmagnitude"

#define MIN_MAG_VALUE @"2.5"

@interface EarthshakeBaseViewController : UIViewController

@property (strong, nonatomic) NSNumberFormatter *decimalFormatter;

- (void)getRequestDataSuccess:(EarthshakeSuccessBlock)success failure:(EarthshakeFailureBlock)failure;
- (void)didSelectRefresh;
- (void)displayAlert:(NSError *)error;

@end
