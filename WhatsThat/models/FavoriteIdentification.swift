//
//  FavoriteIdentification.swift
//  WhatsThat
//
//  Created by Ismayil Hasanov on 11/20/17.
//  Copyright © 2017 GWU. All rights reserved.
//

import Foundation
import UIKit

// Used to archive/unarchive label and image combination for favorites functionality
class FavoriteIdentification: NSObject {
    let label: String
    let image: UIImage

    let labelKey = "label"
    let imageKey = "image"
    
    init(label: String, image: UIImage) {
        
        self.label = label
        self.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        label = aDecoder.decodeObject(forKey: labelKey) as! String
        image = aDecoder.decodeObject(forKey: imageKey) as! UIImage
    }
}

extension FavoriteIdentification: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(label, forKey: labelKey)
        aCoder.encode(image, forKey: imageKey)
    }
}
