//
//  API.swift
//
//  Created by Matt Kauper on 3/10/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import Foundation
import UIKit

open class API {

    static func getDogs(_ completion: @escaping (Profile?, Error?) -> Void) {
        let requestURL: URL = URL(string: "https://dog.ceo/api/breeds/list")!
        let task = URLSession.shared.dataTask(with: requestURL, completionHandler: {
            (data, response, error) -> Void in

            guard let httpResponse = response as? HTTPURLResponse, error == nil, httpResponse.statusCode == 200, let data = data else {
                completion(nil, error)
                return
            }

            // TODO: Debug

            // TODO: Codable

        })
        task.resume()
    }

    static func getDogPicture(breedName: String, _ completion: @escaping (Headshot?, Error?) -> Void) {
        let dogImageUrl = String("https://dog.ceo/api/breed/\(breedName)/images/random")
        let requestURL: URL = URL(string: dogImageUrl)!
        let task = URLSession.shared.dataTask(with: requestURL, completionHandler: {
            (data, response, error) -> Void in

            guard let httpResponse = response as? HTTPURLResponse, error == nil, httpResponse.statusCode == 200, let data = data else {
                completion(nil, error)
                return
            }

            do {
                let decoder = JSONDecoder()
                let jsondata = try decoder.decode(Headshot.self, from: data)
                completion(jsondata, nil)
            } catch let error as NSError {
                NSLog("JSON Parsing error: \(error)")
                completion(nil, error)
            }
        })
        task.resume()
    }

}
