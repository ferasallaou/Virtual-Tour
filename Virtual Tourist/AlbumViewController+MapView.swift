//
//  AlbumViewController+MapView.swift
//  Virtual Tourist
//
//  Created by Feras Allaou on 2/27/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import Foundation
import MapKit

extension AlbumViewController: MKMapViewDelegate {
    
    func setMapAnnotation(lat: Double, lon: Double){
        self.snapShotMapView.isZoomEnabled = false
        self.snapShotMapView.isScrollEnabled = false
        self.snapShotMapView.isUserInteractionEnabled = false
        let annotation = MKPointAnnotation()
        let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        annotation.coordinate = coordinates
        let region = MKCoordinateRegionMakeWithDistance(coordinates, 1000, 1000)
        self.snapShotMapView.region = region
        self.snapShotMapView.addAnnotation(annotation)
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
    
}
