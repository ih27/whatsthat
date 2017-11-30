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
    let regionRadius: CLLocationDistance = 1000
    var isInitialLocation = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the map view delegate to the the class itself
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addMapAnnotations()
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
    func addMapAnnotations() {
        // Fetch the favorites
        favorites = Persistance.sharedInstance.fetchIdentifications()
        favorites.forEach { favorite in
            mapView.addAnnotation(favorite)
        }
    }
}

extension FavoritePhotosMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        centerMapOnInitialLocation(userLocation.location)
        // Toggle the flag so that the map is not centered constantly
        isInitialLocation = false        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? FavoriteIdentification else { return nil }
        // 3
        let identifier = "marker"
        if #available(iOS 11.0, *) {
            var view: MKMarkerAnnotationView
            // 4
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 5
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            return view
        } else {
            return nil
        }
    }
}