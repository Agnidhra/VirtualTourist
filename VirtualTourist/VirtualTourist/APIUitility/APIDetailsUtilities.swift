//
//  APIDetailsUtilities.swift
//  VirtualTourist
//
//  Created by Agnidhra Gangopadhyay on 6/13/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import Foundation

extension APIDetails {
    func getCall( _ function : String? = nil, _ url : URL? = nil, parameters : [String: String],
        completionHandlerForGET: @escaping (_ result: Data?, _ error: NSError?) -> Void) -> URLSessionDataTask {

        let request: NSMutableURLRequest!
        if let url = url {
            request = NSMutableURLRequest(url: url)
        } else {
            request = NSMutableURLRequest(url: buildURL(parameters, withPathExtension: function))
        }
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            func captureIssue(_ error: String) {
                completionHandlerForGET(nil, NSError(domain: "getCall", code: 1, userInfo: [NSLocalizedDescriptionKey : error]))
            }
            if let error = error {
                if (error as NSError).code == URLError.cancelled.rawValue {
                    completionHandlerForGET(nil, nil)
                } else {
                    captureIssue("Error in Response : \(error.localizedDescription)")
                }
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                captureIssue("Your request returned a status code other than 2xx!")
                return
            }

            guard let data = data else {
                captureIssue("Error in Data!")
                return
            }

            completionHandlerForGET(data, nil)

        }
        task.resume()
        return task
    }
    
   public func buildURL(_ apiParameters: [String: String], withPathExtension: String? = nil) -> URL {
       var urlComponents = URLComponents()
       urlComponents.scheme = "https"
       urlComponents.host = "api.flickr.com"
       urlComponents.path = "/services/rest" + (withPathExtension ?? "")
       urlComponents.queryItems = [URLQueryItem]()
       
       for (key, value) in apiParameters {
           let queryItem = URLQueryItem(name: key, value: value)
           urlComponents.queryItems!.append(queryItem)
       }
       return urlComponents.url!
   }

   public func gettingTheAreaBox(latitude: Double, longitude: Double) -> String {
       let minLongitutde = max(longitude - 0.2, -180.0)
       let minLatitutde = max(latitude  - 0.2, -90.0)
       let maxLongitude = min(longitude + 0.2, 180.0)
       let maxLatitude = min(latitude  + 0.2, 90.0)
       return "\(minLongitutde),\(minLatitutde),\(maxLongitude),\(maxLatitude)"
   }
    
}
