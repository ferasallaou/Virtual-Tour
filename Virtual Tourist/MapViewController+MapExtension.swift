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
                let predicate = NSPredicate(format: "albumId == %@", annotationId!)
                let deleteRequest = dataController.deleteFrom(entityName: "Albums", fetchFormat: predicate)
                if deleteRequest {
                    self.mapView.removeAnnotation(annotation)
                    let deletePredicate = NSPredicate(format: "albumId == %@", annotationId!)
                    let deletePhotos = self.dataController.deleteFrom(entityName: "Photos", fetchFormat: deletePredicate)
                    if !deletePhotos {
                        showAlert(title: "Error in Deletion", message: "There was an Error deleting all Photos Associated!")
                    }
                }else{
                    showAlert(title: "Error in Deletion", message: "Please try again.")
                }
                
            }else{
                let albumVC = self.storyboard?.instantiateViewController(withIdentifier: "albumVC") as! AlbumViewController
                                
                albumVC.latitude = (view.annotation?.coordinate.latitude)!
                albumVC.longitude = (view.annotation?.coordinate.longitude)!
                albumVC.albumId = Int64(annotation.title!!)!
                self.mapView.deselectAnnotation(annotation, animated: false)
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
            self.mapView.addAnnotation(annotation)

            let parameters = ["albumId": albumId! as AnyObject,
                              "latitude": newCoordinates.latitude as AnyObject,
                              "longitude": newCoordinates.longitude as AnyObject
            ]
            
            self.dataController.saveAlbum(parameters: parameters)
            
        }
    }
   
    func addAnnotationsToMap()  {
        
        let albumsData = appDelegate.albumsArray
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
