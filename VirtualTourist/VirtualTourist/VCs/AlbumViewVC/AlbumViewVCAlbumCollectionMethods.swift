//
//  AlbumView+Extension.swift
//  VirtualTourist
//
//  Created by Agnidhra Gangopadhyay on 6/14/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import CoreData

extension AlbumViewVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsControllerPhotoDetails.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sectionInfo = self.fetchedResultsControllerPhotoDetails.sections?[section] {
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as! PhotoCell
        cell.imageView.image = nil
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photo = fetchedResultsControllerPhotoDetails.object(at: indexPath)
        let photoViewCell = cell as! PhotoCell
        photoViewCell.imagePath = photo.imagePath!
        setupPhoto(using: photoViewCell, photo: photo, collectionView: collectionView, index: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoToDelete = fetchedResultsControllerPhotoDetails.object(at: indexPath)
        CoreDataStackDetails.getSharedInstance().currentMOContext.delete(photoToDelete)
        saveCurrentContext()
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying: UICollectionViewCell, forItemAt: IndexPath) {
        
        if collectionView.cellForItem(at: forItemAt) == nil {
            return
        }
        
        let photo = fetchedResultsControllerPhotoDetails.object(at: forItemAt)
        if let imageUrl = photo.imagePath {
            APIDetails.sharedInstance().stop(imageUrl)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setPhotoCollectionLayout(size)
    }
}
