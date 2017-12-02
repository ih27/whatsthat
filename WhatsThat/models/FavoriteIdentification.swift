//
//  FavoriteIdentification.swift
//  WhatsThat
//
//  Created by Ismayil Hasanov on 11/20/17.
//  Copyright © 2017 GWU. All rights reserved.
//

import Foundation
import UIKit
import MapKit

// Used to archive/unarchive label and filename combination for favorites functionality
class FavoriteIdentification: NSObject, MKAnnotation {
    let label: String
    let filename: URL
    let coordinate: CLLocationCoordinate2D // Needed for map annotation
    let latitude: Double?
    let longitude: Double?

    let labelKey = "label"
    let filenameKey = "filename"
    let latitudeKey = "latitude"
    let longitudeKey = "longitude"
    
    init(label: String, filename: URL, latitude: Double?, longitude: Double?) {
        
        self.label = label
        self.filename = filename
        self.latitude = latitude
        self.longitude = longitude
        
        if let lat = latitude, let lon = longitude {
            self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        } else {
            self.coordinate = CLLocationCoordinate2D()
        }
    }
    
    // A computed property for map annotations
    var title: String? {
        return label.capitalized
    }
    
    required init?(coder aDecoder: NSCoder) {
        label = aDecoder.decodeObject(forKey: labelKey) as! String
        filename = aDecoder.decodeObject(forKey: filenameKey) as! URL
        latitude = aDecoder.decodeObject(forKey: latitudeKey) as? Double
        longitude = aDecoder.decodeObject(forKey: longitudeKey) as? Double
        
        if let lat = latitude, let lon = longitude {
            coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        } else {
            coordinate = CLLocationCoordinate2D()
        }
    }
}

extension FavoriteIdentification: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(label, forKey: labelKey)
        aCoder.encode(filename, forKey: filenameKey)
        aCoder.encode(latitude, forKey: latitudeKey)
        aCoder.encode(longitude, forKey: longitudeKey)
    }
}
