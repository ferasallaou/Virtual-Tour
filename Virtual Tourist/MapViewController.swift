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
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Virtual Tourist"
        getUserLocation()
        startGestureListener()
        appDelegate.mainMapView = self.mapView
//        let lastSavedLocation = appDelegate.userDefaults.value(forKey: "lastSavedLocation")
        
    }
    
    @IBOutlet weak var editMapViewBtn: UIBarButtonItem!

    
    func getUserLocation() {
        if let savedLocation = appDelegate.userDefaults.value(forKey: "lastSavedLocation") {
            let newRegion = convertDictionaryToRegion(dictionary: savedLocation as! [String: AnyObject])
            mapView.setRegion(newRegion, animated: true)
        }else{
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
    

}

