//
//  GoogleVisionResult.swift
//  What's That
//
//  Created by Ismayil Hasanov on 11/14/17.
//  Copyright © 2017 GWU. All rights reserved.
//

import Foundation

struct GoogleVisionResult: Decodable {
    let name: String
    let address: String
    let logoUrlString: String
    
    enum CodingKeys: String, CodingKey {
    case name // matches above
    case address // matches above
    case logoUrlString = "image_url"
    }
}
