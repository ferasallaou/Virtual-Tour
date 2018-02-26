//
//  MapViewController+MapExtension.swift
//  Virtual Tourist
//
//  Created by Feras Allaou on 2/26/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController: MKMapViewDelegate {
 
    
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
        
        if let annotation = view.annotation{

            let annotationId = annotation.title!
            if self.isEditMode {
                let deleteRequest = dataController.deleteFrom(entityName: "Albums", fetchFormat: "albumId == \(annotationId!)")
                if deleteRequest {
                    self.mapView.removeAnnotation(annotation)
                }else{
                    showAlert(title: "Error in Deletion", message: "Please try again.   ")
                }
                
            }else{
                let albumVC = self.storyboard?.instantiateViewController(withIdentifier: "albumVC") as! AlbumViewController
                let getPredicate = NSPredicate(format: "albumId == %@", annotationId!)
                let getData = dataController.fetchFrom(entityName: "Albums", predicate: getPredicate)
                let imageData = getData.last?.value(forKey: "snapshot") as! Data
                let image = UIImage(data: imageData)
                albumVC.locationImage = image!
                albumVC.latitude = (view.annotation?.coordinate.latitude)!
                albumVC.longitude = (view.annotation?.coordinate.longitude)!
                albumVC.albumId = Int64(annotation.title!!)!
                self.navigationController?.pushViewController(albumVC, animated: true)
            }
            
        }
        
    }
    
    @objc func dropPin(gestureRecognizer:UIGestureRecognizer) {
        
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates
            annotation.title = "\(Int(Date().timeIntervalSince1970))"
            let albumId = Int(annotation.title!)
            //dataController.getEntity(entityNamae: "Albums")
            var imageData = Data()
            createSnapShot(location: newCoordinates) {
                (data, error) in
                if error != nil {
                    print("Just an error")
                }else{
                    
                    self.mapView.addAnnotation(annotation)
                    imageData = data!
                    let parameters = ["albumId": albumId! as AnyObject,
                                      "snapshot": imageData as AnyObject,
                                      "latitude": newCoordinates.latitude as AnyObject,
                                      "longitude": newCoordinates.longitude as AnyObject
                    ]
                    self.dataController.save(parameters: parameters)
                    
                }
            }
        }
    }
   
    func addAnnotationsToMap()  {
        
        let albumsData = appDelegate.albumsArray
        print(albumsData.count)
        for sd in albumsData {
            print("\(sd.albumId) - \(sd.latitude) - \(sd.longitude)")
        }
        var mapAnnot = [MKAnnotation]()
        for savedPins in albumsData{
            let lat = savedPins.latitude
            let long = savedPins.longitude
            let title = savedPins.albumId
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            annotation.title = "\(title)"
            mapAnnot.append(annotation)
        }
        
        self.mapView.addAnnotations(mapAnnot)
    }
    
    
}
