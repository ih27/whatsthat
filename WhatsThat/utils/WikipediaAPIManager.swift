//
//  WikipediaAPIManager.swift
//  WhatsThat
//
//  Created by Ismayil Hasanov on 11/17/17.
//  Copyright © 2017 GWU. All rights reserved.
//

import Foundation

protocol WikipediaDelegate {
    func resultFound(_ result: WikipediaResult)
    func resultNotFound(reason: WikipediaAPIManager.FailureReason)
}

class WikipediaAPIManager {
    
    enum FailureReason: String {
        case networkRequestFailed = "Network request failed, please try again."
        case badJSONResponse = "Something went wrong."
        case noExtractFound = "The Wikipedia page is not found for this identification."
    }
    
    var delegate: WikipediaDelegate?
    
    // API related constant.
    let apiUrl = "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro=&titles="
    
    func fetchExtract(for query: String) {
        let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let requestURL = URL(string: apiUrl+escapedQuery)!
        let urlRequest = URLRequest(url: requestURL)
        let task = URLSession.shared.dataTask(with: urlRequest) {
            (data, response, error) -> Void in
            
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                self.delegate?.resultNotFound(reason: .networkRequestFailed)
                return
            }
            
            // Parse the results
            self.parseResults(with: data)
        }
        
        task.resume()
    }
    
    // Parse the returned result to our wiki model object
    private func parseResults(with dataToParse: Data) {
        // Convert Data to JSON object
        guard let data = try? JSONSerialization.jsonObject(with: dataToParse, options: []) else {
            self.delegate?.resultNotFound(reason: .badJSONResponse)
            return
        }
        
        // Cast the JSON object as dictionary
        guard let dataAsJson = data as? [String: Any] else {
            self.delegate?.resultNotFound(reason: .badJSONResponse)
            return
        }
        
        // Extract the query object
        guard let queryData = dataAsJson["query"] as? [String: Any] else {
            self.delegate?.resultNotFound(reason: .badJSONResponse)
            return
        }
        
        // Extract the pages object
        guard let pagesData = queryData["pages"] as? [String: Any] else {
            self.delegate?.resultNotFound(reason: .badJSONResponse)
            return
        }
        
        // Cast the pages as dictionary
        guard let pageDictionary = pagesData[pagesData.keys.first!] as? [String: Any] else {
            self.delegate?.resultNotFound(reason: .badJSONResponse)
            return
        }
        
        // Try to cast the page related info as Data and decode to WikipediaResult model
        let page = try? JSONSerialization.data(withJSONObject: pageDictionary)
        let jsonDecoder = JSONDecoder()
        let decodedResult = try? jsonDecoder.decode(WikipediaResult.self, from: page!)
        guard let result = decodedResult else {
            self.delegate?.resultNotFound(reason: .badJSONResponse)
            return
        }
        
        // The extract may be nil
        guard result.extract != nil else {
            self.delegate?.resultNotFound(reason: .noExtractFound)
            return
        }

        // Return the result to the conformee
        self.delegate?.resultFound(result)
    }
}
