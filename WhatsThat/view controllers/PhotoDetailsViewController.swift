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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idLabel.text = wikipediaTerm
        
        // Add favorite button
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
