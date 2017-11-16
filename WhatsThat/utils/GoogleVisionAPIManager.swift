//
//  GoogleVisionAPIManager.swift
//  WhatsThat
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
    
    // API related constant. The key only works inside THIS app :-)
    let apiUrl = "https://vision.googleapis.com/v1/images:annotate?key=AIzaSyCOVYcFNb7JraAOwQLAmcSCBm-sRu1lAao"
    
    func fetchIdentifications(for image: UIImage) {
        let requestURL = URL(string: apiUrl)!
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        urlRequest.httpBody = prepareJsonRequestData(for: image)
        
        let task = URLSession.shared.dataTask(with: urlRequest) {
            (data, response, error) -> Void in
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            
            self.analyzeResults(data)
        }
        
        task.resume()
    }
    
    private func resultsFromJsonData(data: Data) -> [GoogleVisionResult] {
        let decoder = JSONDecoder()
        let googleVisionResults = try? decoder.decode([GoogleVisionResult].self, from: data)
        return googleVisionResults ?? [GoogleVisionResult]()
    }
    
    // TODO: Correct
    func analyzeResults(_ dataToParse: Data) {
            
        // Use SwiftyJSON to parse results
        let json = try! JSON(data: dataToParse)
        let errorObj: JSON = json["error"]
        
        // Check for errors
        if (errorObj.dictionaryValue != [:]) {
            print("Error code \(errorObj["code"]): \(errorObj["message"])")
        } else {
            // Parse the response
            let responses: JSON = json["responses"][0]
            
            // Get web entities
            // let webEntities: JSON = responses["webDetection"]["webEntities"]
            
            // Get label annotations
            let labelAnnotations: JSON = responses["labelAnnotations"]
            
            // TODO: test
            // Serialize the JSONs
//            guard let jsonWebData = try? webEntities.rawData() else {
//                return
//            }
            guard let jsonLabelData = try? labelAnnotations.rawData() else {
                return
            }
            
            // let webResults = resultsFromJsonData(data: jsonWebData)
            let labelResults = resultsFromJsonData(data: jsonLabelData)
            
            // Results: sorted by score
            let results = labelResults.sorted(by: { $0.score > $1.score })
            
            // TODO: handle success
            self.delegate?.resultsFound(results)
        }
    }
    
    // Return the JSON given the image for Cloud Vision API
    private func prepareJsonRequestData(for image: UIImage) -> Data? {
        // Prepare json data
        let jsonRequest = [
            "requests": [
                "image": [
                    "content": base64Encode(image)
                ],
                "features": [
                    [
                        "type": "LABEL_DETECTION",
                        "maxResults": 10
                    ]
                ]
            ]
        ]
        let jsonObject = JSON(jsonRequest)
        
        // Serialize the JSON
        guard let data = try? jsonObject.rawData() else {
            return nil
        }
        return data
    }
    
    // Convert the image to base64 encoded string
    private func base64Encode(_ image: UIImage) -> String {
        let compressionQuality: CGFloat = 0.7
        var imageData = UIImageJPEGRepresentation(image, compressionQuality) ?? Data()
        
        // Resize the image if it exceeds the 2MB API limit (borrowed from Google Vision API sample)
        if (imageData.count > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imageData = resize(image, to: newSize)
        }
        
        return imageData.base64EncodedString()
    }
    
    // Resize the image to newSize (borrowed from Google Vision API sample)
    private func resize(_ image: UIImage, to imageSize: CGSize) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let compressionQuality: CGFloat = 0.7
        let resizedImage = UIImageJPEGRepresentation(newImage!, compressionQuality)
        UIGraphicsEndImageContext()
        return resizedImage!
    }
}
