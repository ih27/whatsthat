//
//  LocationFinder.swift
//  WhatsThat
//
//  Created by Ismayil Hasanov on 11/28/17.
//  Copyright © 2017 GWU. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationFinderDelegate {
    func locationFound(latitude: Double, longitude: Double)
    func locationNotFound()
}

class LocationFinder: NSObject {
    
    let locationManager = CLLocationManager()
    
    var delegate: LocationFinderDelegate?
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        // optional desired accuracy
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func findLocation() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            delegate?.locationNotFound()
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        case .authorizedAlways:
            // do nothing, irrelevant
            break
        }
    }
}

extension LocationFinder: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first!
        delegate?.locationFound(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        } else {
            delegate?.locationNotFound()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        delegate?.locationNotFound()
    }
}
