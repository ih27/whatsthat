//
//  FavoritePhotosMapViewController.swift
//  WhatsThat
//
//  Created by Ismayil Hasanov on 11/29/17.
//  Copyright © 2017 GWU. All rights reserved.
//

import UIKit
import MapKit

class FavoritePhotosMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var favorites = [FavoriteIdentification]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Fetch the favorites
        favorites = Persistance.sharedInstance.fetchIdentifications()
        favorites.forEach { favorite in
            mapView.addAnnotation(favorite)
        }
    }
}
