//
//  AlbumViewController.swift
//  Virtual Tourist
//
//  Created by Feras Allaou on 2/22/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController {

    @IBOutlet weak var locationSnapshot: UIImageView!
    var locationImage =  UIImage()
    var albumId: Int64 = 0
    var latitude: Double = 0
    var longitude: Double = 0
    
    let dataController = DataController()
    let flickrClient = FlickrClient()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationSnapshot.image = locationImage
        getSavedPhotosOrFetch(albumId: albumId) 
        // Do any additional setup after loading the view.
    }

    
    @IBAction func getNewCollection(_ sender: Any) {
       //dataController.deleteAll(entityName: "Photos")
        let checkPhotos = dataController.fetchFrom(entityName: "Photos", predicate:nil)
        print(checkPhotos.count)
        for dd in checkPhotos {
            let album = dd.value(forKey: "albumId")
            //let da = dd.value(forKey: "photo")
            
            print("\(album) for ")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
