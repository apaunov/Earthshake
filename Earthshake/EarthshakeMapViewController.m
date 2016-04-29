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
#import "PlaceAnnotation.h"

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

    [self.tabBarController setTitle: NSLocalizedString(@"Earthshake Map", nil)];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.mapView.delegate = self;

    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startMonitoringSignificantLocationChanges];
    [self.locationManager startUpdatingLocation];

    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;

    self.mapView.showsUserLocation = YES;
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay: -7];

    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDate *endTime = [NSDate date];
    NSDate *startTime = [calender dateByAddingComponents:dateComponents toDate:endTime options:0];

    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[dateFormatter stringFromDate:startTime] forKey:kStartTime];
    [parameters setObject:[dateFormatter stringFromDate:endTime] forKey:kEndTime];
    [parameters setObject:@"2.5" forKey:kMinMagnitude];

    self.earthshakeService = [(EarthshakeAppDelegate *)[[UIApplication sharedApplication] delegate] earthshakeService];
    
    [self.earthshakeService getRequestData: parameters
                                   success: ^(NSArray * earthshakeItems)
     {
         self.earthshakeItems = [earthshakeItems copy];

         for (EarthshakeItem *earthshakeItem in self.earthshakeItems)
         {
             PlaceAnnotation *earthshakeAnnotation = [[PlaceAnnotation alloc] init];
             earthshakeAnnotation.title = earthshakeItem.place;
             earthshakeAnnotation.subtitle = [NSString stringWithFormat:@"%.1f %@", [earthshakeItem.magnitude floatValue], NSLocalizedString(@"magnitude", nil)];
             earthshakeAnnotation.coordinate = earthshakeItem.epicenter;
             earthshakeAnnotation.magnitude = earthshakeItem.magnitude;

             [self.mapView addAnnotation:earthshakeAnnotation];
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
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, [self distanceConverter:1000], [self distanceConverter:1000]);
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

#pragma mark Map delegates

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];

    if (![annotation isKindOfClass:[MKUserLocation class]])
    {
        if ([annotation isKindOfClass:[PlaceAnnotation class]])
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *forwardImage = [UIImage imageNamed:@"Show More"];

            button.frame = CGRectMake(0, 0, forwardImage.size.width, forwardImage.size.height);
            [button setImage:forwardImage forState:UIControlStateNormal];

            annotationView.rightCalloutAccessoryView = button;
        }
    }
    else
    {
        return nil;
    }

    annotationView.canShowCallout = YES;

    return annotationView;
}

#pragma mark Custom methods

- (int)distanceConverter:(int)kilometers
{
    return kilometers * kRegionDistanceMultiplier;
}

@end
