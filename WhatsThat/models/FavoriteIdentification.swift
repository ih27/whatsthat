//
//  FavoriteIdentification.swift
//  WhatsThat
//
//  Created by Ismayil Hasanov on 11/20/17.
//  Copyright © 2017 GWU. All rights reserved.
//

import Foundation
import UIKit

// Used to archive/unarchive label and filename combination for favorites functionality
class FavoriteIdentification: NSObject {
    let label: String
    let filename: URL

    let labelKey = "label"
    let filenameKey = "filename"
    
    init(label: String, filename: URL) {
        
        self.label = label
        self.filename = filename
    }
    
    required init?(coder aDecoder: NSCoder) {
        label = aDecoder.decodeObject(forKey: labelKey) as! String
        filename = aDecoder.decodeObject(forKey: filenameKey) as! URL
    }
}

extension FavoriteIdentification: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(label, forKey: labelKey)
        aCoder.encode(filename, forKey: filenameKey)
    }
}
