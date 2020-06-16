//
//  PinDetails.swift
//  VirtualTourist
//
//  Created by Agnidhra Gangopadhyay on 6/13/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import Foundation
import CoreData

@objc(PinDetails)
public class PinDetails: NSManagedObject {
    
    static let tableName = "PinDetails"
    
    convenience init(latCoordinate: String, longCoordinate: String, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: PinDetails.tableName, in: context) {
            self.init(entity: ent, insertInto: context)
            
            self.latCoordinate = latCoordinate
            self.longCoordinate = longCoordinate
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
}

extension PinDetails {
    @NSManaged public var latCoordinate: String?
    @NSManaged public var longCoordinate: String?
    @NSManaged public var details_of_photos: NSSet?
}

