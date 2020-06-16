//
//  AlbumViewVC.swift
//  VirtualTourist
//
//  Created by Agnidhra Gangopadhyay on 6/14/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class AlbumViewVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var albumViewMapView: MKMapView!
    @IBOutlet weak var albumCollection: UICollectionView!
    @IBOutlet weak var newCollectionButton: UIButton!
    @IBOutlet weak var photoCollectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var fetchedResultsControllerPhotoDetails: NSFetchedResultsController<PhotoDetails>!
    var shouldShowAlert = false
    var pinDetails: PinDetails?
    
    var numberOfPages: Int? = nil
    var currentIndexes = [IndexPath]()
    var add: [IndexPath]!
    var delete: [IndexPath]!
    var update: [IndexPath]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        setPhotoCollectionLayout(view.frame.size)
        albumViewMapView.delegate = self
        albumViewMapView.isZoomEnabled = false
        albumViewMapView.isScrollEnabled = true
        
        guard let pinDetails = pinDetails else { return }
        marpMap(pinDetails)
        setFetchedResultControllerForSelectedPin(pinDetails)
        
        if let photos = pinDetails.details_of_photos, photos.count == 0 {
            getPhotosFromServices(pinDetails)
        } else {
            self.updateUIOnMainThread {
                self.loadingIndicator.isHidden = true
                self.loadingIndicator.stopAnimating()
            }
        }
    }
    
    
    @IBAction func resetCollection(_ sender: Any) {
        self.updateUIOnMainThread {
            self.loadingIndicator.isHidden = false
            self.loadingIndicator.startAnimating()
        }
       for photos in fetchedResultsControllerPhotoDetails.fetchedObjects! {
           CoreDataStackDetails.getSharedInstance().currentMOContext.delete(photos)
       }
       saveCurrentContext()
       getPhotosFromServices(pinDetails!)
    }
    
    func setPhotoCollectionLayout(_ withSize: CGSize) {
        let landscape = withSize.width > withSize.height
        let spacing: CGFloat = landscape ? 5 : 3
        let numberOfItems: CGFloat = landscape ? 2 : 3
        let size = (withSize.width - ((numberOfItems + 1) * spacing)) / numberOfItems
        
        photoCollectionViewFlowLayout?.minimumInteritemSpacing = spacing
        photoCollectionViewFlowLayout?.minimumLineSpacing = spacing
        photoCollectionViewFlowLayout?.itemSize = CGSize(width: size, height: size)
        photoCollectionViewFlowLayout?.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
    
    func setupPhoto(using cell: PhotoCell, photo: PhotoDetails, collectionView: UICollectionView, index: IndexPath) {
        if let imageData = photo.imageData {
            cell.imageView.image = UIImage(data: Data(referencing: imageData))
        } else {
            if let imageUrl = photo.imagePath {
                APIDetails.sharedInstance().getImage(imagePath: imageUrl) { (data, error) in
                    if let _ = error {
                        self.showAlert(withTitle: "Error", message: "Error while getting Image form path: \(imageUrl)")
                        return
                    } else if let data = data {
                        self.updateUIOnMainThread {
                            if let currentCell = collectionView.cellForItem(at: index) as? PhotoCell {
                                if currentCell.imagePath == imageUrl {
                                    currentCell.imageView.image = UIImage(data: data)
                                }
                            }
                            photo.imageData = NSData(data: data)
                            DispatchQueue.global(qos: .background).async { self.saveCurrentContext() }
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Service Call Handling
    
    private func getPhotosFromServices(_ pinDetails: PinDetails) {
        let latitude = Double(pinDetails.latCoordinate!)!
        let longitude = Double(pinDetails.longCoordinate!)!
        APIDetails.sharedInstance().searchImagesInCoordinates(lat: latitude, long: longitude, numberOfImages: numberOfPages) { (photosResults, error) in
            if let result = photosResults {
                self.numberOfPages = result.photos.pages
                let totalPhotos = result.photos.photo.count
                self.savePhotos(result.photos.photo, forPin: pinDetails)
                if totalPhotos == 0 {
                    self.showAlert(message: "No Photos for this place, Try selecting a different place !!")
                }
            } else if let error = error {
                self.showAlert(withTitle: "Error", message: error.localizedDescription)
            }
            self.updateUIOnMainThread {
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.isHidden = true
            }
            
        }
    }
    
}
