//
//  AlbumViewController+Extension.swift
//  Virtual Tourist
//
//  Created by Feras Allaou on 2/24/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import Foundation
import UIKit

extension AlbumViewController {
    
    func getSavedPhotosOrFetch(mAlbumId: Int64) {
        
        print("Gona Fetch For \(mAlbumId)")
        
        let getPredicate = NSPredicate(format: "albumId == %@", argumentArray: [mAlbumId])
        let tryToFetch = dataController.fetchFrom(entityName: "Photos", predicate: getPredicate)
        var photosDataArray = [Data]()
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
                
                for singlePhoto in flickrPhotos! {
                  let photoURL = singlePhoto["url_s"] as? String
                    self.getImageDataFromUrl(url: photoURL!){
                        (convertedPhoto, errorPhoto) in
                        
                        
                        guard errorPhoto == nil else{
                            print("No Photo Data were returned.")
                            return
                        }
                     
                        photosDataArray.append(convertedPhoto!)
                    }
                }
                
                // Now we got our Photos in Data Format, let's save it to the Datbase :)
                let dataToSave = [
                    "\(mAlbumId)": photosDataArray as AnyObject
                ]
                self.dataController.save(parameters: dataToSave)

            }
            
        } else { // end of TryToFetch is Empty
            print("We have photos for \(mAlbumId)")
            
            for singleItem in tryToFetch {
                print(singleItem.value(forKey: "albumId"))
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
