//
//  AlbumViewVCMapViewMethods.swift
//  VirtualTourist
//
//  Created by Agnidhra Gangopadhyay on 6/15/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import Foundation
import MapKit

extension AlbumViewVC {
    public func marpMap(_ pinDetails: PinDetails) {
        
        let latitude = Double(pinDetails.latCoordinate!)!
        let longitude = Double(pinDetails.longCoordinate!)!
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let pinPoint = MKPointAnnotation()
        pinPoint.coordinate = coordinates
        
        albumViewMapView.removeAnnotations(albumViewMapView.annotations)
        albumViewMapView.addAnnotation(pinPoint)
        albumViewMapView.setCenter(coordinates, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
           
           let Id = "pin"
           
           var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: Id) as? MKPinAnnotationView
           
           if pinView == nil {
               pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Id)
               pinView!.canShowCallout = false
               pinView!.pinTintColor = .red
           } else {
               pinView!.annotation = annotation
           }
           
           return pinView
       }
}
