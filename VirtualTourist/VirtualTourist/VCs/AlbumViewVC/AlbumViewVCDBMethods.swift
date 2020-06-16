//
//  AlbumViewVCDBMethods.swift
//  VirtualTourist
//
//  Created by Agnidhra Gangopadhyay on 6/15/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import Foundation
import CoreData

extension AlbumViewVC: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        add = [IndexPath]()
        delete = [IndexPath]()
        update = [IndexPath]()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at index: IndexPath?, for type: NSFetchedResultsChangeType, newIndex: IndexPath?) {
        
        switch (type) {
        case .insert:
            add.append(newIndex!)
            break
        case .delete:
            delete.append(index!)
            break
        case .update:
            update.append(index!)
            break
        case .move:
            print("Move an item. We don't expect to see this in this app.")
            break
        @unknown default: break
            
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        albumCollection.performBatchUpdates({() -> Void in
            for index in self.update { self.albumCollection.reloadItems(at: [index]) }
            for index in self.add { self.albumCollection.insertItems(at: [index]) }
            for index in self.delete { self.albumCollection.deleteItems(at: [index]) }
        }, completion: nil)
    }
    
    func setFetchedResultControllerForSelectedPin(_ pinDetails: PinDetails) {
        
        let fetchRequest = NSFetchRequest<PhotoDetails>(entityName: PhotoDetails.tableName)
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "pin_details == %@", argumentArray: [pinDetails])
        
        fetchedResultsControllerPhotoDetails = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStackDetails.getSharedInstance().currentMOContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsControllerPhotoDetails.delegate = self as NSFetchedResultsControllerDelegate
        var error: NSError?
        do {
            try fetchedResultsControllerPhotoDetails.performFetch()
        } catch let error1 as NSError {
            error = error1
        }
        
        if let error = error {
            self.showAlert(message: "Error Getting Pin Information: \(error). Try Again")
        }
    }
    
    func savePhotos(_ imageObjects: [photoResults], forPin: PinDetails) {
        for imageObject in imageObjects {
            updateUIOnMainThread {
                if let url = imageObject.url {
                    _ = PhotoDetails(title: imageObject.title, imageUrl: url, forPin: forPin, context: CoreDataStackDetails.getSharedInstance().currentMOContext)
                    self.saveCurrentContext()
                }
            }
        }
        
    }
    
    func loadPhotos(using pin: PinDetails) -> [PhotoDetails]? {       //PENDING SHOULD NOT BE REQUIRED
           let predicate = NSPredicate(format: "pinDetails == %@", argumentArray: [pin])
           var photos: [PhotoDetails]?
           do {
               try photos = CoreDataStackDetails.getSharedInstance().getPhotosFromStore(predicate, tableName: PhotoDetails.tableName)
           } catch {
               print("\(#function) error:\(error)")
               showAlert(withTitle: "Error", message: "Error while lading Photos from disk: \(error)")
           }
           return photos
       }
}
