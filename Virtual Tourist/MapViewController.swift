//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by Feras Allaou on 2/20/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var userLocation: CLLocationCoordinate2D? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Virtual Tourist"
        getUserLocation()
        startGestureListener()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var editMapViewBtn: UIBarButtonItem!

    
    func getUserLocation() {
        locationManager.requestWhenInUseAuthorization()
        let isLocationAuth = CLLocationManager.authorizationStatus()
        if isLocationAuth != .authorizedAlways && isLocationAuth != .authorizedWhenInUse {
            showAlert(title: "Location Service", message: "This app needs to use Location Service, Please grant the permissions.")
        }else if !CLLocationManager.locationServicesEnabled(){
           showAlert(title: "Location Service", message: "Location Service is Disabled.")
        }else{
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.distanceFilter = 100.0  // In meters.
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }
    

}

