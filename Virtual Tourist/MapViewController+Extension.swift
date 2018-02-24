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
        print("Here")
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
                let getData = dataController.fetchFrom(entityName: "Albums", predicate: annotationId!)
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
        annotation.title = "\(Int(Date().timeIntervalSince1970))"
            let albumId = Int(annotation.title!)
            dataController.getEntity(entityNamae: "Albums")
            var imageData = Data()
            createSnapShot(location: newCoordinates) {
                (data, error) in
                
                if error != nil {
                    print("Just an error")
                }else {
                self.mapView.addAnnotation(annotation)
                  imageData = data!
                    let parameters = ["albumId": albumId! as AnyObject,
                                      "snapshot": imageData as AnyObject,
                                      "latitude": newCoordinates.latitude as AnyObject,
                                      "longitude": newCoordinates.longitude as AnyObject
                    ]
                    self.dataController.save(parameters: parameters, parameterAsArray: nil)
                    
                }
            }
        }
    }
    
    func createSnapShot(location: CLLocationCoordinate2D, createSSCompletion: @escaping (Data?, String?) -> Void)  {
        var snapshotImg = UIImage()
        //var imageAsData = Data()
        let mapSnapshotOptions = MKMapSnapshotOptions()
        
        // Set the region of the map that is rendered.
        
        let mLocation = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        let region = MKCoordinateRegionMakeWithDistance(mLocation, 1000, 1000)
        mapSnapshotOptions.region = region
        
        // Set the scale of the image. We'll just use the scale of the current device, which is 2x scale on Retina screens.
        mapSnapshotOptions.scale = UIScreen.main.scale
        
        // Set the size of the image output.
        mapSnapshotOptions.size = CGSize(width: 600, height: 300)
        
        // Show buildings and Points of Interest on the snapshot
        mapSnapshotOptions.showsBuildings = true
        mapSnapshotOptions.showsPointsOfInterest = true
        
        let snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
        snapShotter.start { (snapshot, error) in
            
        guard  error == nil else {
                createSSCompletion(nil, "There was an Error Creating a Snapshot")
                return
            }
            
            if let image = snapshot?.image {
                snapshotImg =  image
            }

            UIGraphicsBeginImageContextWithOptions(snapshotImg.size, true, snapshotImg.scale)
            snapshotImg.draw(at: CGPoint.zero)
            let pin = MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)

            let visibleRect = CGRect(origin: CGPoint.zero, size: snapshotImg.size)

            var point = snapshot?.point(for: mLocation)
                if visibleRect.contains(point!) {
                    point!.x = point!.x + pin.centerOffset.x - (pin.bounds.size.width / 2)
                    point!.y = point!.y + pin.centerOffset.y - (pin.bounds.size.height / 2)
                    pin.image?.draw(at: point!)
                }
            
            
            let compositeImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let data = UIImageJPEGRepresentation(compositeImage!, 1)
            
            
             //imageAsData = UIImageJPEGRepresentation(snapshotImg, 1)!
            createSSCompletion(data,nil)
        }
    }
    
    
    func addAnnotationsToMap()  {
        let myData = dataController.fetchFrom(entityName: "Albums",predicate:  nil)
        var mapAnnot = [MKAnnotation]()
        for savedPins in myData{
            let lat = savedPins.value(forKey: "latitude") as! Double
            let long = savedPins.value(forKey: "longitude") as! Double
            let title = savedPins.value(forKey: "albumId") as! Int64
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            annotation.title = "\(title)"
            mapAnnot.append(annotation)
        }
        
        self.mapView.addAnnotations(mapAnnot)
    }
    
    
    
}
