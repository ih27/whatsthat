//
//  GoogleVisionResponse.swift
//  WhatsThat
//
//  Created by Ismayil Hasanov on 11/17/17.
//  Copyright © 2017 GWU. All rights reserved.
//

import Foundation

struct GoogleVisionResponse: Decodable {
    let labelAnnotations: [GoogleVisionLabel]?
}
