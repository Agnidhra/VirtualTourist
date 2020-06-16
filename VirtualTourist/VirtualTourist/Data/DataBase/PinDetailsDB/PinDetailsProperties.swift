//
//  PinDetailsProperties.swift
//  VirtualTourist
//
//  Created by Agnidhra Gangopadhyay on 6/13/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import Foundation
import CoreData

extension PinDetails {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PinDetails> {
        return NSFetchRequest<PinDetails>(entityName: "PinDetails")
    }
}

extension PinDetails {
    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: PhotoDetails)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: PhotoDetails)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)
}
