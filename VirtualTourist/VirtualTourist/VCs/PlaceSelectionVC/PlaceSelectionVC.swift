//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Agnidhra Gangopadhyay on 6/13/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import UIKit
import MapKit

class PlaceSelectionVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var placeSelectionMapView: MKMapView!
    @IBOutlet weak var toastMessage: UILabel!
    
    var pinMarking: MKPointAnnotation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toastMessage.isHidden = true
        placeSelectionMapView.delegate = self
        
        if let pinDetails = getAllPinDetails() {
            displayPins(pinDetails)
        }
        navigationItem.rightBarButtonItem = editButtonItem
        
    }
    
    @IBAction func selectPinByLongPress(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: placeSelectionMapView)
        let locCoord = placeSelectionMapView.convert(location, toCoordinateFrom: placeSelectionMapView)
        
        if sender.state == .began {
            pinMarking = MKPointAnnotation()
            pinMarking!.coordinate = locCoord
            placeSelectionMapView.addAnnotation(pinMarking!)
        } else if sender.state == .changed {
            pinMarking!.coordinate = locCoord
        } else if sender.state == .ended {
            _ = PinDetails(
                latCoordinate: String(pinMarking!.coordinate.latitude),
                longCoordinate: String(pinMarking!.coordinate.longitude),
                context: CoreDataStackDetails.getSharedInstance().currentMOContext
            )
            saveCurrentContext()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AlbumViewVC {
            guard let pinDetails = sender as? PinDetails else {
                return
            }
            let controller = segue.destination as! AlbumViewVC
            controller.pinDetails = pinDetails
        }
    }
    
}





