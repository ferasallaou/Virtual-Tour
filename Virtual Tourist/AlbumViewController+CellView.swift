//
//  AlbumViewController+CellView.swift
//  Virtual Tourist
//
//  Created by Feras Allaou on 2/24/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import Foundation
import UIKit

extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! CustomCellCollectionView
        let singleItem = photosArray[indexPath.row]
        let image = UIImage(data: singleItem.photo!)
        cell.singleImage.image = image!
        return cell
    }
    

    
    
    
}
