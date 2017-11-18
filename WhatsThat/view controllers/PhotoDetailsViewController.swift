//
//  PhotoDetailsViewController.swift
//  WhatsThat
//
//  Created by Ismayil Hasanov on 11/15/17.
//  Copyright © 2017 GWU. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
    @IBOutlet weak var idLabel: UILabel!
    var favoritePressed = false
    var iconName = "heart"
    
    // The term passed from PhotoIdentification view
    var wikipediaTerm = ""
    
    // The photo passed from PhotoIdentification view (in case if needed for the favorite thumbnail
    var photo: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idLabel.text = wikipediaTerm
        
        // Add favorite button to the navigation bar
        if favoritePressed {
            iconName = "heart-filled"
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: iconName), style: .plain, target: self, action: #selector(favoriteTapped))
    }
    
    // Toggle for favorite button
    @objc func favoriteTapped() {
        if favoritePressed {
            favoritePressed = false
            iconName = "heart"
        } else {
            favoritePressed = true
            iconName = "heart-filled"
        }
        
        // Set the new image for the favorite button
        navigationItem.rightBarButtonItem?.image = UIImage(named: iconName)
    }
}
