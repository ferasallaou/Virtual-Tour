//
//  MapViewController+Extension.swift
//  Virtual Tourist
//
//  Created by Feras Allaou on 2/20/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let tryUserLocation = locations.last {
            userLocation = tryUserLocation.coordinate
        }else{
            // set it to Where Magic Happend :))
            print("Came HEre")
            userLocation = CLLocationCoordinate2D(latitude: 37.332, longitude: -122.01)
        }
        mapView.setCenter(userLocation!, animated: true)
    }
    
    func showAlert(title: String,message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okBtn)
        present(alert, animated: true, completion: nil)
    }
    
    func startGestureListener(){
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(dropPin))
        mapView.addGestureRecognizer(gesture)
    }
    
    @objc func dropPin(gestureRecognizer:UIGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: mapView)
        let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
        mapView.addAnnotation(annotation)
    }
}
