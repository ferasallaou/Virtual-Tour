//
//  AlbumViewController.swift
//  Virtual Tourist
//
//  Created by Feras Allaou on 2/22/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController {

    @IBOutlet weak var layoutFlow: UICollectionViewFlowLayout!
    @IBOutlet weak var locationSnapshot: UIImageView!
    var locationImage =  UIImage()
    var albumId: Int64 = Int64()
    var latitude: Double = 0
    var longitude: Double = 0
    var photosArray = [Photos]()
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    let dataController = DataController()
    let flickrClient = FlickrClient()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationSnapshot.image = locationImage
        getSavedPhotosOrFetch(mAlbumId: albumId)
        adjustLayoutFlow()
        // Do any additional setup after loading the view.
    }

    @IBAction func deleter(_ sender: Any) {
           dataController.deleteAll(entityName: "Photos")
    }
    
    @IBAction func getNewCollection(_ sender: Any) {
        let predicate = NSPredicate(format: "albumId == %d", albumId)
        let checkPhotos = dataController.fetchFrom(entityName: "Photos", predicate: predicate)
        if !checkPhotos.isEmpty {
            photosArray = []
            for dd in checkPhotos {
                
                let album = dd as! Photos
                photosArray.append(album)
                photosCollectionView.reloadData()
            }
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
