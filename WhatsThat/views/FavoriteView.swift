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
                print("something wrong")
                return
            }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            let imageName = favorite.filename.path
            //image = UIImage(contentsOfFile: imageName)
            
            // Resize image
            let pinImage = UIImage(contentsOfFile: imageName)
            
            let size = CGSize(width: 50.0, height: 50.0)
            // Scale image to fit within specified size while maintaining aspect ratio
            let aspectScaledToFitImage = pinImage?.af_imageAspectScaled(toFill: size)
            image = aspectScaledToFitImage?.af_imageRoundedIntoCircle()
            
//            let size = CGSize(width: 50, height: 50)
//            let resizedImage = UIImage.circle(diameter: 20, color: .orange)
//            UIGraphicsBeginImageContext(size)
//            pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
//            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
            
            
        }
    }
}
