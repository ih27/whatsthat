//
//  FavoritePhotosTableViewController.swift
//  WhatsThat
//
//  Created by Ismayil Hasanov on 11/20/17.
//  Copyright © 2017 GWU. All rights reserved.
//

import UIKit

class FavoritePhotosTableViewController: UITableViewController {
    
    var favorites = [FavoriteIdentification]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Disable the section header by setting the height to minimum
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//
//        return CGFloat.leastNormalMagnitude
//    }
    
    // Number of rows in the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favorites.count
    }
    
    // Set the preperties for each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath)

         // Configure the cell...
        let favorite = favorites[indexPath.row]
        cell.textLabel?.text =
        "\(favorite.label)"
        
        return cell
    }

}
