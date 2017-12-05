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
    func locationNotFound(reason: LocationFinder.FailureReason)
}

class LocationFinder: NSObject {
    
    enum FailureReason: String {
        case noPermission = "You need to give \"While Using the App\" access in Location"
        case timeout = "It took too long to get the location."
        case generic = "Something went wrong with the location services."
    }
    
    let locationManager = CLLocationManager()
    
    var delegate: LocationFinderDelegate?
    var timer = Timer()
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        // optional desired accuracy
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    private func startTimer() {
        
        cancelTimer()
        timer = Timer.scheduledTimer(withTimeInterval: Constants.timerInterval, repeats: false) { timer in
            //code that will run 10 seconds later
            self.locationManager.stopUpdatingLocation()
            self.delegate?.locationNotFound(reason: .timeout)
        }
    }
    
    private func cancelTimer() {
        timer.invalidate()
    }
    
    func findLocation() {
        
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            delegate?.locationNotFound(reason: .noPermission)
        case .authorizedWhenInUse:
            startTimer()
            locationManager.requestLocation()
        case .authorizedAlways:
            // do nothing, irrelevant
            break
        }
    }
}

// Implement CoreLocation delegate functions
extension LocationFinder: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        cancelTimer()
        manager.stopUpdatingLocation()
        
        let location = locations.first!
        delegate?.locationFound(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            startTimer()
            locationManager.requestLocation()
        } else {
            delegate?.locationNotFound(reason: .noPermission)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        cancelTimer()
        delegate?.locationNotFound(reason: .generic)
    }
}
