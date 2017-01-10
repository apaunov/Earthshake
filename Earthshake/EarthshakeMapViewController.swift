//
//  EarthshakeMapViewController.swift
//  Earthshake
//
//  Created by Andrey on 2017-01-03.
//  Copyright © 2017 AP. All rights reserved.
//

import Foundation
import MapKit

class EarthshakeMapViewController: EarthshakeBaseViewController, CLLocationManagerDelegate, MKMapViewDelegate
{
    // UI properties
    @IBOutlet weak var mapView: MKMapView!
    
    // Local properties
    var userLocation: CLLocation?
    var locationManager = CLLocationManager()
    var earthshakeItems = [EarthshakeItem]()        // All accuired items
    var showMapDetailsSegueIdentifier = ""          // Identifier to help distinguish between segues
    var selectedPlaceAnnotation = PlaceAnnotation() // Place annotation container to be passed when tapping an annotation for details

    override func viewDidLoad()
    {
        super.viewDidLoad()

        tabBarController?.title = "Earthshake Map".localized
        showMapDetailsSegueIdentifier = "ShowMapDetails"
        locationManager = CLLocationManager()
        locationManager.delegate = self
        mapView.delegate = self

        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone

        mapView.showsUserLocation = true
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true

        loadMapData()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last

        // If the user location is not present then update to the last location on the list
        if userLocation == nil
        {
            // The distance is measured in kilometers
            var region = MKCoordinateRegionForMapRect(MKMapRectWorld)
            region.center = (location?.coordinate)!
            
            mapView.setRegion(region, animated: true)
        }

        userLocation = location!
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        let errorType = error.localizedDescription
        let alert = UIAlertController(title: "Error getting Location".localized, message: errorType, preferredStyle: UIAlertControllerStyle.alert)

        let cancelAction = UIAlertAction(title: "OK".localized, style: UIAlertActionStyle.default)
        {
            (action) in
            alert.dismiss(animated: true, completion: {})
        }

        alert.addAction(cancelAction)
        present(alert, animated: true) {}
    }
    
    // Map delegates
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier:"pin")

        if !annotation.isKind(of: MKUserLocation.self)
        {
            if annotation.isKind(of: PlaceAnnotation.self)
            {
                let button = UIButton(type: UIButtonType.custom)
                let forwardImage = UIImage(named: "Show More")
                
                button.frame = CGRect(x: 0, y: 0, width: forwardImage!.size.width, height: forwardImage!.size.height)
                button.setImage(forwardImage, for: UIControlState.normal)

                annotationView.rightCalloutAccessoryView = button
            }
        }
        else
        {
            return nil
        }
        
        annotationView.canShowCallout = true
        
        return annotationView;
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        if (view.annotation?.isKind(of: PlaceAnnotation.self))!
        {
            selectedPlaceAnnotation = view.annotation as! PlaceAnnotation
            performSegue(withIdentifier: showMapDetailsSegueIdentifier, sender: self)
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    
        if segue.identifier == showMapDetailsSegueIdentifier
        {
            if segue.destination.isKind(of: EarthshakeDetailsViewController.self)
            {
                let destination = segue.destination as! EarthshakeDetailsViewController
                destination.detailURLString = selectedPlaceAnnotation.detailURLString
            }
        }
    }

    // Helper methods

    func loadMapData()
    {
        super.getRequestedData(
            success:
            {
                earthshakeItems in

                self.earthshakeItems = earthshakeItems as! [EarthshakeItem]

                for earthshakeItem in self.earthshakeItems
                {
                    let earthshakeAnnotation = PlaceAnnotation()
                    earthshakeAnnotation.placeTitle = earthshakeItem.place
                    earthshakeAnnotation.placeSubtitle = String(format: "%@ %@", super.decimalFormatter.string(from: earthshakeItem.magnitude)!, "magnitude".localized)
                    earthshakeAnnotation.coordinate = earthshakeItem.epicenter
                    earthshakeAnnotation.magnitude = earthshakeItem.magnitude
                    earthshakeAnnotation.detailURLString = earthshakeItem.detailURLString

                    self.mapView.addAnnotation(earthshakeAnnotation)
                }
        })
        {
            error in
            super.displayAlert(error: error)
        }
    }
    
    override func didSelectRefresh()
    {
        super.didSelectRefresh()

        mapView.removeAnnotation(mapView.annotations as! MKAnnotation)

        loadMapData()
    }
}
