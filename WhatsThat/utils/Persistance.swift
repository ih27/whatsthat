//
//  Persistance.swift
//  WhatsThat
//
//  Created by Ismayil Hasanov on 11/20/17.
//  Copyright © 2017 GWU. All rights reserved.
//

import Foundation
import UIKit

class Persistance {
    // Singleton instance property
    static let sharedInstance = Persistance()
    
    let userDefaults = UserDefaults.standard
    let identificationsKey = "identifications"
    
    // To make the class singleton
    private init() {
    }
    
    // Check if the favorite with a given label and a filename exists
    func doFavoritesContain(_ label: String, _ filename: URL) -> Bool {
        let image = UIImage(contentsOfFile: filename.path)!
        
        let favorites = fetchIdentifications()
        
        for favorite in favorites {
            let favImage = UIImage(contentsOfFile: favorite.filename.path)!
            if favorite.label == label && areEqualImages(image, favImage) {
                return true
            }
        }
        return false
    }
    
    // Get the saved identifications
    func fetchIdentifications() -> [FavoriteIdentification] {
        
        let data = userDefaults.object(forKey: identificationsKey) as? Data
        
        if let data = data {
            //data is not nil, so use it
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? [FavoriteIdentification] ?? [FavoriteIdentification]()
        }
        else {
            //data is nil
            return [FavoriteIdentification]()
        }
    }
    
    // Save the passed in identification
    func saveIdentification(_ label: String, _ filename: URL) {
        
        //print("\(label): \(image.debugDescription)")
        // Create a FavoriteIdentification object out of label and filename
        let identification = FavoriteIdentification(label: label, filename: filename)
        
        var identifications = fetchIdentifications()
        //print(identifications)
        identifications.append(identification)
        let data = NSKeyedArchiver.archivedData(withRootObject: identifications)
        userDefaults.set(data, forKey: identificationsKey)
    }
    
    // Delete the identification matching the label and image
    func deleteIdentification(_ label: String, _ filename: URL) {
        
        // print("\(label) <==> \(image.debugDescription)")
        let identifications = fetchIdentifications()
        // Filter the matched identification
        let modifiedIdentifications = identifications.filter { $0.label != label && $0.filename != filename }
        // print("original: \(identifications)\nmodified: \(modifiedIdentifications)")
        
        // identifications.append(identification)
        let data = NSKeyedArchiver.archivedData(withRootObject: modifiedIdentifications)
        userDefaults.set(data, forKey: identificationsKey)
    }
    
    private func areEqualImages(_ lhs: UIImage, _ rhs: UIImage) -> Bool {
        
        guard let lhsData = UIImagePNGRepresentation(lhs) else { return false }
        guard let rhsData = UIImagePNGRepresentation(rhs) else { return false }
        
        return lhsData == rhsData
    }
}
