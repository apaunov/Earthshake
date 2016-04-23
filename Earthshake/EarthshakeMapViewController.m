//
//  FirstViewController.m
//  Earthshake
//
//  Created by Andrey Paunov on 2016-03-24.
//  Copyright © 2016 Andrey Paunov. All rights reserved.
//

#import "EarthshakeMapViewController.h"
#import "EarthshakeAppDelegate.h"
#import "EarthshakeService.h"
#import "EarthshakeItem.h"
#import "PlaceItem.h"

#define kRegionDistanceMultiplier 1000

@interface EarthshakeMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocation *userLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) id<EarthshakeService> earthshakeService; // Protocal to interact with the request service
@property (strong, nonatomic) NSArray *earthshakeItems;                // All accuired items

@end

@implementation EarthshakeMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tabBarController setTitle: @"Earthshake Map"];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startMonitoringSignificantLocationChanges];
    [self.locationManager startUpdatingLocation];

    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;

    self.mapView.showsUserLocation = YES;
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
    
    NSDictionary *parameters = @{
                                 @"format" : @"geojson",
                                 @"starttime" : @"2016-04-22",
                                 @"endtime" : @"2016-04-23"
                                 };

    self.earthshakeService = [(EarthshakeAppDelegate *)[[UIApplication sharedApplication] delegate] earthshakeService];
    
    [self.earthshakeService getRequestData:parameters
                                   success:^(NSArray * earthshakeItems)
     {
         self.earthshakeItems = [earthshakeItems copy];

         for (EarthshakeItem *earthshakeItem in self.earthshakeItems)
         {
             PlaceItem *earthshakePlace = [[PlaceItem alloc] init];
             earthshakePlace.coordinate = earthshakeItem.epicenter;
             [self.mapView addAnnotation:earthshakePlace];
         }
     }
                                   failure:^(NSError *error)
     {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:[error description]
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil, nil];
         [alert show];
     }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];

    if (!self.userLocation)
    {
        // The distance is measured in kilometers
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, [self distanceConverter:10], [self distanceConverter:10]);
        [self.mapView setRegion:region];
    }

    self.userLocation = location;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSString *errorType = (error.code == kCLErrorDenied) ? @"Access Denied" : @"Unknown Error";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: @"Error getting Location"
                                                                   message: errorType
                                                            preferredStyle: UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle: @"OK"
                                                           style: UIAlertActionStyleDefault
                                                         handler: ^(UIAlertAction *action)
    {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];

    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Custom methods

- (int)distanceConverter:(int)kilometers
{
    return kilometers * kRegionDistanceMultiplier;
}

@end
