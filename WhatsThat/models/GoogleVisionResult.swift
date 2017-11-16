//
//  GoogleVisionResult.swift
//  WhatsThat
//
//  Created by Ismayil Hasanov on 11/14/17.
//  Copyright © 2017 GWU. All rights reserved.
//

import Foundation

struct GoogleVisionResult: Decodable, Hashable, Equatable {
    var hashValue: Int { get { return description.lowercased().hashValue } }
    
    let description: String
    let score: Decimal
    
    static func ==(lhs: GoogleVisionResult, rhs: GoogleVisionResult) -> Bool {
        return lhs.description.lowercased() == rhs.description.lowercased()
    }
}
