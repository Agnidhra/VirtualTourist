//
//  PhotoCell.swift
//  VirtualTourist
//
//  Created by Agnidhra Gangopadhyay on 6/14/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import Foundation
import UIKit
class PhotoCell: UICollectionViewCell {
    static let identifier = "PhotoCell"
    
    var imagePath: String = ""
    @IBOutlet weak var imageView: UIImageView!
}
