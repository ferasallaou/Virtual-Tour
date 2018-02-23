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

    @IBOutlet weak var editModeLable: UILabel!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var userLocation: CLLocationCoordinate2D? = nil
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var isEditMode: Bool = false
    let dataController = DataController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Virtual Tourist"
        getUserLocation()
        startGestureListener()
        appDelegate.mainMapView = self.mapView
        
    }
    
    @IBAction func testing(_ sender: Any) {
     let myData = dataController.fetchFrom(entityName: "Albums",predicate:  nil)
        print("we have \(myData.count)")
        for d in myData{
            let toInt = d.value(forKey: "albumId") as! Int64
            let imageData = d.value(forKey: "snapshot") as? Data
            print( " \(toInt) thisis data \(imageData)")
        }
        
        
        //dataController.deleteAll(entityName: "Albums")
        
//        let flickrClient = FlickrClient()
//        let params = [
//            "lat": 48.453 as AnyObject,
//            "lon": -89.496 as AnyObject,
//        ]
//        let url = flickrClient.prepareParameters(params: params)
//        flickrClient.getPhotos(url: url) {
//            (data, error) in
//
//            if error != nil {
//                print(error! + "OOps")
//            }else {
//                print("got it \(data?.count)")
//            }
//        }
    }
    @IBAction func editMapViewBtn(_ sender: Any) {
        if isEditMode {
            isEditMode = false
            self.editBtn.title = "Edit"
            UIView.animate(withDuration: 0.5, animations:{
              self.mapView.layer.position.y += 75
              self.editModeLable.layer.position.y += 75
            })
        }else{
            isEditMode = true
            self.editBtn.title = "Done"
            UIView.animate(withDuration: 0.5, animations:{
                self.mapView.layer.position.y -= 75
                self.editModeLable.layer.position.y -= 75
            })
            
        }
        
    }
    
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

