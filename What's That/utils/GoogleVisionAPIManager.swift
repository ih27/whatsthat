//
//  GoogleVisionAPIManager.swift
//  What's That
//
//  Created by Ismayil Hasanov on 11/10/17.
//  Copyright © 2017 GWU. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

protocol GoogleVisionDelegate {
    func resultsFound(_ results: [GoogleVisionResult])
    func resultsNotFound()
}

class GoogleVisionAPIManager {
    
    var delegate: GoogleVisionDelegate?
    
    // API related constants. The key only works inside THIS app :-)
    let apiKey = "AIzaSyCOVYcFNb7JraAOwQLAmcSCBm-sRu1lAao"
    let apiUrl = "https://vision.googleapis.com/v1/images:annotate?key=\(apiKey)"
    
    func fetchIdentifications(for image: UIImage) {
        let requestURL = URL(string: apiUrl)!
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        urlRequest.httpBody = prepareJsonRequestData(for: image)
        
        let task = URLSession.shared.dataTask(with: urlRequest) {
            (data, response, error) -> Void in
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                if let data = data, let resultsJsonArray = try? JSONSerialization.jsonObject(with: data, options: []) {
                    
                    if let resultsJsonArray = resultsJsonArray as? [[String:Any]] {
                        var googleVisionResults = [GoogleVisionResult]()
                        
//                        for gymJsonObject in gymJsonArray {
//                            // parse data from JSON
//                            let gymName = gymJsonObject["name"] as? String ?? ""
//                            let gymAddress = gymJsonObject["address"] as? String ?? ""
//                            let gymImageUrl = gymJsonObject["image_url"] as? String ?? ""
//
//                            let gym = Gym(name: gymName, address: gymAddress, logoUrlString: gymImageUrl)
//                            gyms.append(gym)
//                        }
                        
                        //TODO: handle success
                        self.delegate?.resultsFound(googleVisionResults)
                    }
                    else {
                        //TODO: handle failure - Incorrect JSON array
                        self.delegate?.resultsNotFound()
                    }
                }
                else {
                    //TODO: handle failure - JSON serialization failed
                    self.delegate?.resultsNotFound()
                }
            }
            else {
                //TODO: handle failure - response status code is NOT 200
                self.delegate?.resultsNotFound()
            }
        }
        
        task.resume()
    }
    
    private func gymsFromJsonData(data: Data) -> [GoogleVisionResult] {
        let decoder = JSONDecoder()
        let googleVisionResults = try? decoder.decode([GoogleVisionResult].self, from: data)
        
        return googleVisionResults ?? [GoogleVisionResult]()
    }
    
    private func prepareJsonRequestData(for image: UIImage) -> Data? {
        // Prepare json data
        let jsonRequest = [
            "requests": [
                "image": [
                    "content": base64Encode(image)
                ],
                "features": [
                    [
                        "type": "WEB_DETECTION",
                        "maxResults": 5
                    ],
                    [
                        "type": "LABEL_DETECTION",
                        "maxResults": 5
                    ]
                ]
            ]
        ]
        let jsonObject = JSON(jsonDictionary: jsonRequest)
        
        // Serialize the JSON
        guard let data = try? jsonObject.rawData() else {
            return
        }
        
        return data
    }
    
    private func base64Encode(_ image: UIImage) -> String {
        let compressionQuality: CGFloat = 0.7
        let imageData = UIImageJPEGRepresentation(image, compressionQuality)
        return imageData?.base64EncodedString() ?? ""
    }
}
