//
//  PhotoDetails.swift
//  VirtualTourist
//
//  Created by Agnidhra Gangopadhyay on 6/13/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import Foundation
import CoreData

@objc(PhotoDetails)
public class PhotoDetails: NSManagedObject {
    
    static let tableName = "PhotoDetails"
    
    convenience init(title: String, imageUrl: String, forPin: PinDetails, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: PhotoDetails.tableName, in: context) {
            self.init(entity: ent, insertInto: context)
            self.titleText = title
            self.imageData = nil
            self.imagePath = imageUrl
            self.pin_details = forPin
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
    
}

extension PhotoDetails {
    @NSManaged public var imageData: NSData?
    @NSManaged public var titleText: String?
    @NSManaged public var imagePath: String?
    @NSManaged public var pin_details: PinDetails?
}
