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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let getSelectedItem = collectionView.cellForItem(at: indexPath)
        if self.itemsToDelete.contains(indexPath) {
            getSelectedItem?.alpha = 1.0
            let getItemsIndex = self.itemsToDelete.index(of: indexPath)
            self.itemsToDelete.remove(at: getItemsIndex!)
        }else{
            getSelectedItem?.alpha = 0.3
            self.itemsToDelete.append(indexPath)
        }
        
        
        if itemsToDelete.count > 0 {
            self.newCollectionBtn.setTitle("Delete Selected", for: UIControlState.normal)
        }else{
            self.newCollectionBtn.setTitle("New Collection", for: UIControlState.normal)
        }
        
        
    }

    
    
    
}
