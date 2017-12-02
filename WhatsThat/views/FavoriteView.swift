//
//  FavoriteView.swift
//  WhatsThat
//
//  Created by Ismayil Hasanov on 12/1/17.
//  Copyright © 2017 GWU. All rights reserved.
//

import Foundation
import MapKit
import AlamofireImage

class FavoriteView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let favorite = newValue as? FavoriteIdentification else {
                return
            }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            let imageName = favorite.filename.path
            let pinImage = UIImage(contentsOfFile: imageName)
            
            // Scale image to fit within specified size while maintaining aspect ratio
            let size = CGSize(width: 50.0, height: 50.0)
            let aspectScaledToFitImage = pinImage?.af_imageAspectScaled(toFill: size)
            // Make it a circle
            image = aspectScaledToFitImage?.af_imageRoundedIntoCircle()
        }
    }
}
