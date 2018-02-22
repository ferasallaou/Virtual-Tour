//
//  MapViewController+Extension.swift
//  Virtual Tourist
//
//  Created by Feras Allaou on 2/20/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let tryUserLocation = locations.last {
            userLocation = tryUserLocation.coordinate
        }else{
            // set it to Where Magic Happend :))
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
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.pinTintColor = .red
            pinView!.animatesDrop = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(isEditMode)
        if let annotation = view.annotation{
            if self.isEditMode {
            self.mapView.removeAnnotation(annotation)
            }
            
        }
        
    }
    

    func convertDictionaryToRegion(dictionary: [String: AnyObject]) -> MKCoordinateRegion{
        let centerDictionary = dictionary["center"]
        let spanDictionary = dictionary["span"]
        let center = CLLocationCoordinate2D(latitude: centerDictionary!["latitude"] as! CLLocationDegrees, longitude: centerDictionary!["longitude"] as! CLLocationDegrees)
        let span = MKCoordinateSpan(latitudeDelta: spanDictionary!["latitudeDelta"] as! CLLocationDegrees, longitudeDelta: spanDictionary!["longitudeDelta"] as! CLLocationDegrees)
        
        let region = MKCoordinateRegion(center: center, span: span)
        return region
    }
    
    func startGestureListener(){
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(dropPin))
        mapView.addGestureRecognizer(gesture)
    }
    
    @objc func dropPin(gestureRecognizer:UIGestureRecognizer) {
        if gestureRecognizer.state == .began {
        let touchPoint = gestureRecognizer.location(in: mapView)
        let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
        mapView.addAnnotation(annotation)
        }
    }
    
}
