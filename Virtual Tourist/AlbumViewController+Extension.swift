//
//  AlbumViewController+Extension.swift
//  Virtual Tourist
//
//  Created by Feras Allaou on 2/24/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension AlbumViewController{
    
    func getSavedPhotosOrFetch(mAlbumId: Int64) {
       // self.photosCollectionView.addSubview(self.activityIndicator)

        photosCollectionView.isHidden = true
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
        self.newCollectionBtn.isEnabled = false
        let getPredicate = NSPredicate(format: "albumId == %@", argumentArray: [mAlbumId])
        let tryToFetch = dataController.fetchFrom(entityName: "Photos", predicate: getPredicate)

        if tryToFetch.isEmpty {
            
            // let's get somephotos and save them to our database :)
            
            let params = ["lat": latitude as AnyObject,
                          "lon": longitude as AnyObject]
            let url = flickrClient.prepareParameters(params: params)
            
            flickrClient.getPhotos(url: url) {
                (flickrPhotos, error) in
                
                guard error == nil else {
                    print("Oops \(error!)")
                    return
                }
                
                self.photosArray = []
                for singlePhoto in flickrPhotos! {
                  let photoURL = singlePhoto["url_s"] as? String
                    self.getImageDataFromUrl(url: photoURL!){
                        (convertedPhoto, errorPhoto) in

                        guard errorPhoto == nil else{
                            print("No Photo Data were returned.")
                            return
                        }
                        
                        let newPhotoObject = Photos(context: self.dataController.managedContext)
                        newPhotoObject.albumId = mAlbumId
                        newPhotoObject.photo = convertedPhoto!
                    
                        self.dataController.savePhoto(parameters: newPhotoObject)
                        self.photosArray.append(newPhotoObject)
                    }
                }
                
          
                DispatchQueue.main.async {
                    self.photosCollectionView.reloadData()
                    self.newCollectionBtn.isEnabled = true
                    self.photosCollectionView.isHidden = false
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                }
             
            }
            
        } else { // end of TryToFetch is Empty

            self.photosArray = []
            self.photosArray = tryToFetch as! [Photos]
            DispatchQueue.main.async {
                self.photosCollectionView.reloadData()
                self.newCollectionBtn.isEnabled = true
                self.photosCollectionView.isHidden = false
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }
            
        }

    }

        func getImageDataFromUrl(url: String, completionHandler: @escaping (Data?, String?)-> Void) {
            
            if let mUrl = URL(string: url) {
                do {
                let imageData = try Data(contentsOf: mUrl)
                completionHandler(imageData,nil)
                }catch{
                    completionHandler(nil, "Couldn't Download Image")
                }
            }
    }
    
    func adjustLayoutFlow(){
        let space:CGFloat = 3
        let mHeight = (view.frame.size.height - (2 * space))
        let mWidth = (view.frame.size.width - (2 * space))
        
        layoutFlow?.minimumInteritemSpacing = space
        layoutFlow?.minimumLineSpacing = space
        layoutFlow?.itemSize = CGSize(width: mWidth/3, height: mHeight/5)
    }
    

    
}
