//
//  String+Extensions.swift
//  WhatsThat
//
//  Created by Ismayil Hasanov on 11/18/17.
//  Copyright © 2017 GWU. All rights reserved.
//

import Foundation
import UIKit

extension String {
    // Converts a standard string to an attributed string for HTML displaying purposes
    func convertHtml() -> NSAttributedString {
        
        do {
            return try NSAttributedString(data: Data(utf8),
                                          options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
}
