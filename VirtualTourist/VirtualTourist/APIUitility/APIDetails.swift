//
//  APIDetails.swift
//  VirtualTourist
//
//  Created by Agnidhra Gangopadhyay on 6/13/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import Foundation
import UIKit

class APIDetails {
    var session = URLSession.shared
    private var actions: [String: URLSessionDataTask] = [:]

    class func sharedInstance() -> APIDetails {
        struct Singleton { static var shared = APIDetails() }
        return Singleton.shared
    }

    func searchImagesInCoordinates(lat: Double, long: Double, numberOfImages: Int?, completion: @escaping (_ result: photosResults?, _ error: Error?) -> Void) {
        var page: Int {
            if let numberOfImages = numberOfImages {
                let page = min(numberOfImages, 4000/30)
                return Int(arc4random_uniform(UInt32(page)) + 1)
            }
            return 1
        }
        let area = gettingTheAreaBox(latitude: lat, longitude: long)

        let parameters = [ "method"         : "flickr.photos.search"
            , "api_key"         : "6915426f0362567c3e871247a3481e89"
            , "format"         : "json"
            , "extras"         : "url_n"
            , "nojsoncallback" : "1"
            , "safe_search"     : "1"
            , "bbox"    : area
            , "per_page"  : "\(21)"
            , "page"           : "\(page)"]

        _ = getCall(parameters: parameters) { (data, error) in
            if let error = error { completion(nil, error); return }
            guard let data = data else {
                completion(nil, NSError(domain: "getCall", code: 1, userInfo: [NSLocalizedDescriptionKey : "Failed to Get Information."]))
                return
            }

            do {
                let pr = try JSONDecoder().decode(photosResults.self, from: data)
                completion(pr, nil)
            } catch { completion(nil, error) }
        }
    }

    func getImage(imagePath: String, result: @escaping (_ result: Data?, _ error: NSError?) -> Void) {
        guard let url = URL(string: imagePath) else {
            return
        }
        let task = getCall(nil, url, parameters: [:]) { (data, error) in
            result(data, error)
            if self.actions.removeValue(forKey: imagePath) != nil {
                return
            }
        }

        if actions[imagePath] == nil {
           actions[imagePath] = task
        }
    }

    func stop(_ imageUrl: String) {
        actions[imageUrl]?.cancel()
        if actions.removeValue(forKey: imageUrl) != nil {
            return
        }
    }
    
    

}
