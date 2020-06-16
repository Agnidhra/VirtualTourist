//
//  CoreDataStackUtilities.swift
//  VirtualTourist
//
//  Created by Agnidhra Gangopadhyay on 6/13/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import Foundation
import CoreData

extension CoreDataStackDetails {
    func getAllPinDetails(_ predicate: NSPredicate? = nil, entityName: String, sortParameter: NSSortDescriptor? = nil) throws -> [PinDetails]? {
        let nsFetchRequestResult = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        nsFetchRequestResult.predicate = predicate
        if let sortParameter = sortParameter {
            nsFetchRequestResult.sortDescriptors = [sortParameter]
        }
        guard let pin = try currentMOContext.fetch(nsFetchRequestResult) as? [PinDetails] else {
            return nil
        }
        return pin
    }
    
    func fetchPinDetails(_ filter: NSPredicate, tableName: String, toSortWith: NSSortDescriptor? = nil) throws -> PinDetails? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
        fetchRequest.predicate = filter
        if let toSortWith = toSortWith {
            fetchRequest.sortDescriptors = [toSortWith]
        }
        guard let pinDetails = (try currentMOContext.fetch(fetchRequest) as! [PinDetails]).first else {
            return nil
        }
        return pinDetails
    }
    
    func getPhotosFromStore(_ filter: NSPredicate? = nil, tableName: String, sorting: NSSortDescriptor? = nil) throws -> [PhotoDetails]? {
        let nsNSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
        nsNSFetchRequest.predicate = filter
        if let sorting = sorting {
            nsNSFetchRequest.sortDescriptors = [sorting]
        }
        guard let photos = try currentMOContext.fetch(nsNSFetchRequest) as? [PhotoDetails] else {
            return nil
        }
        return photos
    }
}
