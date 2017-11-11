//
//  GoogleVisionAPIManager.swift
//  What's That
//
//  Created by Ismayil Hasanov on 11/10/17.
//  Copyright © 2017 GWU. All rights reserved.
//

import Foundation
import UIKit

class GoogleVisionAPIManager {
    // API related constants
    let API_KEY = "AIzaSyCOVYcFNb7JraAOwQLAmcSCBm-sRu1lAao"
    let API_URL = "https://vision.googleapis.com/v1/images:annotate"
    
    private func base64Encode(image: UIImage) -> String {
        let compressionQuality: CGFloat = 0.7
        let imageData = UIImageJPEGRepresentation(image, compressionQuality)
        return imageData?.base64EncodedString() ?? ""
    }
}
