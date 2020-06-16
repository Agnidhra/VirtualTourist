//
//  PhotoDetailsProperties.swift
//  VirtualTourist
//
//  Created by Agnidhra Gangopadhyay on 6/13/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import Foundation
import CoreData

extension PhotoDetails {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoDetails> {
        return NSFetchRequest<PhotoDetails>(entityName: "PhotoDetails")
    }
}
