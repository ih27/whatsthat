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
    let score: Float
}
