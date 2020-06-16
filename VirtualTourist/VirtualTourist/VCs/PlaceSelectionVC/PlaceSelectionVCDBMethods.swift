//
//  PlaceSelectionVCDBMethods.swift
//  VirtualTourist
//
//  Created by Agnidhra Gangopadhyay on 6/15/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import Foundation

extension PlaceSelectionVC {
    public func getAllPinDetails() -> [PinDetails]? {
        var pinDetails: [PinDetails]?
        do {
            try pinDetails = CoreDataStackDetails.getSharedInstance().getAllPinDetails(entityName: PinDetails.tableName)
        } catch {
            showAlert(withTitle: "Error", message: "Error While Getting All The Pin coordinates: \(error)")
            
        }
        return pinDetails
    }
    
    func getPin(latCoordinate: String, longCoordinate: String) -> PinDetails? {
        //let predicate = NSPredicate(format: "latitude == %@ AND longitude == %@", latitude, longitude)
        let predicate = NSPredicate(format: "latCoordinate == %@ AND longCoordinate == %@", latCoordinate, longCoordinate)
        var pin: PinDetails?
        do {
            try pin = CoreDataStackDetails.getSharedInstance().fetchPinDetails(predicate, tableName: PinDetails.tableName)
        } catch {
            print("\(#function) error:\(error)")
            showAlert(withTitle: "Error", message: "Error while getting pin coordinates : \(error)")
        }
        return pin
    }
}

