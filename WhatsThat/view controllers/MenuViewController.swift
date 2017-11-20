//
//  ViewController.swift
//  WhatsThat
//
//  Created by Ismayil Hasanov on 11/6/17.
//  Copyright © 2017 GWU. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favoritesSegue" {
            let favorites = Persistance.sharedInstance.fetchIdentifications()
            // print(favorites)
            let destinationViewController = segue.destination as? FavoritePhotosTableViewController
            destinationViewController?.favorites = favorites
        }
    }
}

