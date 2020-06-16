//
//  APIResponse.swift
//  VirtualTourist
//
//  Created by Agnidhra Gangopadhyay on 6/13/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import Foundation

struct photosResults: Codable {
    let photos: photos
}

struct photos: Codable {
    let pages: Int
    let photo: [photoResults]
}

struct photoResults: Codable {
    
    let url: String?
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case url = "url_n"
        case title
    }
}
