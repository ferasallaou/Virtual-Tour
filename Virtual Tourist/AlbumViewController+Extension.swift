//
//  AlbumViewController+Extension.swift
//  Virtual Tourist
//
//  Created by Feras Allaou on 2/24/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import Foundation


extension AlbumViewController {
    
    func getSavedPhotosOrFetch(albumId: Int64) {
    
       let getPhotos =  dataController.fetchFrom(entityName: "Photos", predicate: "albumId == \(albumId)")
        
        if getPhotos.isEmpty {
            print("There are no photos indeed :( for \(latitude) - \(longitude)")
            let params = [
                "lat": latitude as AnyObject,
                "lon": longitude as AnyObject
            ]
            let url = flickrClient.prepareParameters(params: params)

            flickrClient.getPhotos(url: url){
                (data, error) in
                
                guard error == nil else {
                    print("There was an error! \(error)")
                    return
                }
                
                if data!.isEmpty {
                    print("Flickr has no Photos :(( ")
                }else{
                    self.dataController.getEntity(entityNamae: "Photos")
                    print("We Have \(data!.count)")
                    var counter = 1
                    var dataToSave: [[String: AnyObject]] = []
                    for flickrPhotos in data! {
                        print("Saving \(counter)")
                        let photoURL = flickrPhotos["url_s"] as! String
                        let imgData = try? Data(contentsOf: URL(string: photoURL)!)
                        
                         let dataObject = [
                            "albumId": self.albumId as AnyObject,
                            "photo": imgData! as AnyObject
                        ]
                        dataToSave.append(dataObject)
                        counter += 1
                    }
                    
                    self.dataController.save(parameters: nil, parameterAsArray: dataToSave)
                }
            }
        }else{
            print("Well, let's Print the photos")
        }
    }
    
    
}
