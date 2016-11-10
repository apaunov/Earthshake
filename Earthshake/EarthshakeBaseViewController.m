//
//  EarthshakeBaseViewController.m
//  Earthshake
//
//  Created by Andrey Paunov on 2016-04-24.
//  Copyright © 2016 AP. All rights reserved.
//

#import "EarthshakeBaseViewController.h"

@interface EarthshakeBaseViewController ()

@property (strong, nonatomic) id<EarthshakeService> earthshakeService; // Protocal to interact with the request service
@property (strong, nonatomic) NSMutableDictionary *parameters;         // Dictionary with parameters

@end

@implementation EarthshakeBaseViewController

- (void)viewDidLoad
{
    // Adding the refresh button
    UIButton *refreshBarButton = [UIButton buttonWithType: UIButtonTypeCustom];
    refreshBarButton.frame = CGRectMake(0, 0, 22, 22);
    [refreshBarButton addTarget:self action:@selector(didSelectRefresh) forControlEvents: UIControlEventTouchUpInside];
    [refreshBarButton setBackgroundImage: [UIImage imageNamed: @"Refresh"] forState: UIControlStateNormal];

    UIBarButtonItem *refreshButtonItem = [[UIBarButtonItem alloc] initWithCustomView: refreshBarButton];
    self.navigationItem.rightBarButtonItems = @[refreshButtonItem];

    // Date formatting
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay: -7];

    // Magnitude formatting
    self.decimalFormatter = [[NSNumberFormatter alloc] init];
    self.decimalFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    self.decimalFormatter.maximumFractionDigits = 2;
    self.decimalFormatter.roundingMode = NSNumberFormatterRoundHalfUp;

    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDate *endTime = [NSDate date];
    NSDate *startTime = [calender dateByAddingComponents:dateComponents toDate:endTime options:0];

    self.parameters = [[NSMutableDictionary alloc] init];
    [self.parameters setObject: [dateFormatter stringFromDate:startTime] forKey:kStartTime];
    [self.parameters setObject: [dateFormatter stringFromDate:endTime] forKey:kEndTime];
    [self.parameters setObject: MIN_MAG_VALUE forKey:kMinMagnitude];

    self.earthshakeService = [(EarthshakeAppDelegate *)[[UIApplication sharedApplication] delegate] earthshakeService];
}

#pragma mark - Helper methods

- (void)getRequestDataSuccess:(EarthshakeSuccessBlock)success failure:(EarthshakeFailureBlock)failure
{
    [self.earthshakeService getRequestData:self.parameters success:success failure:failure];
}

- (void)didSelectRefresh
{
}

- (void)displayAlert:(NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", nil)
                                                                   message:error.localizedDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action)
                                    {
                                    }];
    
    [alert addAction:dismissAction];

    [self presentViewController:alert animated:YES completion:nil];
}

@end
