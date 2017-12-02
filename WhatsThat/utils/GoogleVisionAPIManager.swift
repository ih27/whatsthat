//
//  GoogleVisionAPIManager.swift
//  WhatsThat
//
//  Created by Ismayil Hasanov on 11/10/17.
//  Copyright © 2017 GWU. All rights reserved.
//

import Foundation
import UIKit

protocol GoogleVisionDelegate {
    func resultsFound(_ results: [GoogleVisionLabel])
    func resultsNotFound(reason: GoogleVisionAPIManager.FailureReason)
}

class GoogleVisionAPIManager {
    
    enum FailureReason: String {
        case networkRequestFailed = "Network request failed, please try again."
        case badJSONResponse = "Something went wrong."
        case noLabelFound = "The identification is not found for this photo."
    }
    
    var delegate: GoogleVisionDelegate?
    
    // Get the label annotations from Google Vision API
    func fetchIdentifications(for image: UIImage) {
        let requestURL = URL(string: Constants.googleVisionApiUrl)!
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = Constants.googleVisionApiMethod
        urlRequest.addValue(Constants.googleVisionApiContentType, forHTTPHeaderField: "Content-Type")
        urlRequest.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        // Prepare the request data for given image
        urlRequest.httpBody = prepareJsonRequestData(for: image)
        
        let task = URLSession.shared.dataTask(with: urlRequest) {
            (data, response, error) -> Void in
            
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print(error?.localizedDescription ?? "")
                self.delegate?.resultsNotFound(reason: .networkRequestFailed)
                return
            }
            
            // Parse the results
            self.parseResults(with: data)
        }
        
        task.resume()
    }
    
    // Parse the returned result to our label model object
    private func parseResults(with dataToParse: Data) {
        
        let jsonDecoder = JSONDecoder()
        let decodedResult = try? jsonDecoder.decode(GoogleVisionResult.self, from: dataToParse)
        
        guard let result = decodedResult else {
            self.delegate?.resultsNotFound(reason: .badJSONResponse)
            return
        }
        
        let labelResults = result.responses[0].labelAnnotations
            
        // Results: sorted by score
        if let results = labelResults?.sorted(by: { $0.score > $1.score }) {
            // Return the results to the delegate
            self.delegate?.resultsFound(results)
        } else {
            self.delegate?.resultsNotFound(reason: .noLabelFound)
        }
    }
    
    // Return the JSON given the image for Google Vision API
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

        let data = try? JSONSerialization.data(withJSONObject: jsonRequest)
        return data
    }
    
    // Convert the image to base64 encoded string
    private func base64Encode(_ image: UIImage) -> String {
        var imageData = UIImageJPEGRepresentation(image, Constants.compressionQuality) ?? Data()
        
        // Resize the image if it exceeds the 2MB API limit (borrowed from Google Vision API sample)
        if (imageData.count > 2097152) {
            let oldSize = image.size
            let newSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            if let imageData = resize(image, to: newSize) {
                return imageData.base64EncodedString()
            }
        }
        
        return imageData.base64EncodedString()
    }
    
    // Resize the image to newSize (borrowed from Google Vision API sample)
    private func resize(_ image: UIImage, to imageSize: CGSize) -> Data? {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        let resizedImage = UIImageJPEGRepresentation(newImage, Constants.compressionQuality)
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
