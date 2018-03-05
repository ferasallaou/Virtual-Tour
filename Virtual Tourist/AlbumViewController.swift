//
//  AlbumViewController.swift
//  Virtual Tourist
//
//  Created by Feras Allaou on 2/22/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import UIKit
import MapKit

class AlbumViewController: UIViewController {

    var locationImage =  UIImage()
    var albumId: Int64 = Int64()
    var latitude: Double = 0
    var longitude: Double = 0
    var photosArray = [Photos]()
    var itemsToDelete = [IndexPath]()
    
    @IBOutlet weak var newCollectionBtn: UIButton!
    @IBOutlet weak var snapShotMapView: MKMapView!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var layoutFlow: UICollectionViewFlowLayout!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let dataController = DataController()
    let flickrClient = FlickrClient()

    override func viewDidLoad() {
        super.viewDidLoad()

        setMapAnnotation(lat: latitude, lon: longitude)
        getSavedPhotosOrFetch(mAlbumId: albumId)
        adjustLayoutFlow()
  
        // Do any additional setup after loading the view.
    }

    
    @IBAction func getCollectionOrDelete(_ sender: Any) {
        
        if self.itemsToDelete.count > 0 {
            itemsToDelete.sort(by: >)
            print(itemsToDelete)
            for eachItem in itemsToDelete {
                print("this is \(self.photosArray.count) & \(eachItem.row)")
                let getItemToDelete = self.photosArray[eachItem.row]

                let predicate = NSPredicate(format: "photo == %d", argumentArray: [getItemToDelete.photo as Any])
                let deletePhoto = self.dataController.deleteFrom(entityName: "Photos", fetchFormat: predicate)
                if deletePhoto {
                    self.photosArray.remove(at: eachItem.row)
                    self.photosCollectionView.performBatchUpdates({
                        self.photosCollectionView.deleteItems(at: [eachItem])
                        
                    }, completion: nil)
                }
            }
            self.itemsToDelete = []
            self.newCollectionBtn.setTitle("New Collection", for: UIControlState.normal)
        }else{
            let deletePredicate = NSPredicate(format: "albumId == %d", albumId)
            let deletePhotos = self.dataController.deleteFrom(entityName: "Photos", fetchFormat: deletePredicate)
            if deletePhotos {
                self.getSavedPhotosOrFetch(mAlbumId: albumId)
            }else{
                print("Error Deleting")
            }
        }
    
       
        
      
        
    }

}
