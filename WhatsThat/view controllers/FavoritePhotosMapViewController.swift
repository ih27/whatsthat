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
    
    let locationFinder = LocationFinder()
    
    var favorites = [FavoriteIdentification]()
    let regionRadius: CLLocationDistance = 1000
    var isInitialLocation = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationFinder.delegate = self
        // Request location info for map user location
        locationFinder.findLocation()
        
        // Set the map view delegate to the the class itself
        mapView.delegate = self
        
        if #available(iOS 11.0, *) {
            // Show the custom annotation view
            mapView.register(FavoriteView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addMapAnnotations()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Constants.photoDetailsId) {
            let vc = segue.destination as! PhotoDetailsViewController
            let favorite = sender as! FavoriteIdentification
            
            vc.wikipediaTerm = favorite.label
            vc.filename = favorite.filename
        }
    }
    
    // Center the map on a given location for only once
    private func centerMapOnInitialLocation(_ location: CLLocation?) {
        if isInitialLocation {
            if let coordinate = location?.coordinate {
                let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius, regionRadius)
                mapView.setRegion(coordinateRegion, animated: true)
            }
        }
    }

    // Add favorited annotations to the map
    private func addMapAnnotations() {
        // Fetch the favorites
        favorites = Persistance.sharedInstance.fetchIdentifications()
        favorites.forEach { favorite in
            mapView.addAnnotation(favorite)
        }
    }
}

// Implement map view delegate functions
extension FavoritePhotosMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        centerMapOnInitialLocation(userLocation.location)
        // Toggle the flag so that the map is not centered constantly
        isInitialLocation = false        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: Constants.photoDetailsId, sender: view.annotation)
    }
}

// Implement LocationFinder delegate functions
extension FavoritePhotosMapViewController: LocationFinderDelegate {
    func locationFound(latitude: Double, longitude: Double) {
        // Do nothing here. Map view itself handles the location
    }
    
    func locationNotFound() {
        // Display an alert
        displayPermissionAlert(with: Constants.locationPermissionsErrorMessage)
    }
    
    // Display an alert trying to direct users to Settings
    private func displayPermissionAlert(with message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Setting button action
        let settingsAction = UIAlertAction(title: Constants.settingsButtonAlertTitle, style: .default) { action in
            // Get the app settings url
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            // Try to open the app settings url
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            } else {
                return
            }
            
            // If the settings change, iOS kills the app. So, we have to dismiss the view in case the user returns without changing the permissions
            self.navigationController?.popViewController(animated: true)
        }
        
        // Cancel button action
        let cancelAction = UIAlertAction(title: Constants.cancelButtonTitle, style: .default){ action in
            self.navigationController?.popViewController(animated: true)
        }
        
        // Add the actions
        ac.addAction(settingsAction)
        ac.addAction(cancelAction)
        
        // Present the alert
        present(ac, animated: true)
    }
}
