//
//  GoogleVisionResult.swift
//  WhatsThat
//
//  Created by Ismayil Hasanov on 11/14/17.
//  Copyright © 2017 GWU. All rights reserved.
//

import Foundation

struct GoogleVisionResult: Decodable {
    let description: String
    let entityId: String
    let score: Decimal
    
//    enum CodingKeys: String, CodingKey {
//    case name // matches above
//    case address // matches above
//    case logoUrlString = "image_url"
//    }
}
