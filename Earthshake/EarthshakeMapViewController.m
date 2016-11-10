//
//  FirstViewController.m
//  Earthshake
//
//  Created by Andrey Paunov on 2016-03-24.
//  Copyright © 2016 Andrey Paunov. All rights reserved.
//

#import "EarthshakeMapViewController.h"
#import "EarthshakeDetailsViewController.h"
#import "EarthshakeAppDelegate.h"
#import "EarthshakeService.h"
#import "EarthshakeItem.h"
#import "PlaceAnnotation.h"

@interface EarthshakeMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocation *userLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) id<EarthshakeService> earthshakeService;  // Protocal to interact with the request service
@property (strong, nonatomic) NSArray *earthshakeItems;                 // All accuired items
@property (strong, nonatomic) NSString *showMapDetailsSegueIdentifier;  // Identifier to help distinguish between segues
@property (strong, nonatomic) PlaceAnnotation *selectedPlaceAnnotation; // Place annotation container to be passed when tapping an annotation for details

@end

@implementation EarthshakeMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tabBarController setTitle: NSLocalizedString(@"Earthshake Map", nil)];

    self.showMapDetailsSegueIdentifier = @"ShowMapDetails";
    
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

    [self loadMapData];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];

    if (!self.userLocation)
    {
        // The distance is measured in kilometers
        MKCoordinateRegion region = MKCoordinateRegionForMapRect(MKMapRectWorld);
        region.center = location.coordinate;

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

#pragma mark - Map delegates

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

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[PlaceAnnotation class]])
    {
        self.selectedPlaceAnnotation = view.annotation;
        [self performSegueWithIdentifier:self.showMapDetailsSegueIdentifier sender:self];
    }
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    if ([segue.identifier isEqualToString:self.showMapDetailsSegueIdentifier])
    {
        if ([segue.destinationViewController isKindOfClass:[EarthshakeDetailsViewController class]])
        {
            EarthshakeDetailsViewController *destinationViewController = segue.destinationViewController;
            destinationViewController.detailURLString = self.selectedPlaceAnnotation.detailURLString;
        }
    }
}

#pragma mark - Helper methods

- (void)loadMapData
{
    [super getRequestDataSuccess:^(NSArray * earthshakeItems)
     {
         self.earthshakeItems = [earthshakeItems copy];
         
         for (EarthshakeItem *earthshakeItem in self.earthshakeItems)
         {
             PlaceAnnotation *earthshakeAnnotation = [[PlaceAnnotation alloc] init];
             earthshakeAnnotation.title = earthshakeItem.place;
             earthshakeAnnotation.subtitle = [NSString stringWithFormat:@"%@ %@", [self.decimalFormatter stringFromNumber:earthshakeItem.magnitude], NSLocalizedString(@"magnitude", nil)];
             earthshakeAnnotation.coordinate = earthshakeItem.epicenter;
             earthshakeAnnotation.magnitude = earthshakeItem.magnitude;
             earthshakeAnnotation.detailURLString = earthshakeItem.detailURLString;
             
             [self.mapView addAnnotation:earthshakeAnnotation];
         }
     }
                         failure:^(NSError *error)
     {
         [self displayAlert:error];
     }];
}

- (void)didSelectRefresh
{
    [super didSelectRefresh];

    [self.mapView removeAnnotations:self.mapView.annotations];

    [self loadMapData];
}

@end
