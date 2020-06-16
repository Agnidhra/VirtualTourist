//
//  PlaceSelectionVC+Extension.swift
//  VirtualTourist
//
//  Created by Agnidhra Gangopadhyay on 6/13/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import Foundation
import MapKit

extension PlaceSelectionVC {
    
    func displayPins(_ pinsDetails: [PinDetails]) {
        for eachPin in pinsDetails where eachPin.latCoordinate != nil && eachPin.longCoordinate != nil {
            let pin = MKPointAnnotation()
            let latitude = Double(eachPin.latCoordinate!)!
            let longitude = Double(eachPin.longCoordinate!)!
            pin.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            placeSelectionMapView.addAnnotation(pin)
        }
        placeSelectionMapView.showAnnotations(placeSelectionMapView.annotations, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.pinTintColor = .red
            pinView!.animatesDrop = true
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            self.showAlert(message: "Invalid Link.")
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let annotation = view.annotation else {
            return
        }

        mapView.deselectAnnotation(annotation, animated: true)
        print("\(#function) lat \(annotation.coordinate.latitude) lon \(annotation.coordinate.longitude)")
        let lat = String(annotation.coordinate.latitude)
        let lon = String(annotation.coordinate.longitude)
        if let pin = getPin(latCoordinate: lat, longCoordinate: lon) {
            if isEditing {
                mapView.removeAnnotation(annotation)
                CoreDataStackDetails.getSharedInstance().currentMOContext.delete(pin)
                saveCurrentContext()
                return
            }
            performSegue(withIdentifier: "loadPhotos", sender: pin)
        }
    }
}
