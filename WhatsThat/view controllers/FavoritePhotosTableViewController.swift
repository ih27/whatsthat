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
    
    // Variables to pass to the details view
    var detailsLabel = ""
    var detailsImage = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Fetch the favorites and reload the table
        favorites = Persistance.sharedInstance.fetchIdentifications()
        tableView.reloadData()
    }

    // Disable the section header by setting the height to minimum
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return CGFloat.leastNormalMagnitude
    }
    
    // Number of rows in the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favorites.count
    }
    
    // Set the properties for each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteTableViewCell

         // Set the label
        let favorite = favorites[indexPath.row]
        cell.favoriteLabel.text =
        "\(favorite.label)"
        
        // Set the thumbnail image
        DispatchQueue.main.async {
            cell.favoriteImageView.image = UIImage(contentsOfFile: favorite.filename.path)
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "PhotoDetails") {

            let vc = segue.destination as! PhotoDetailsViewController
            let favorite = favorites[tableView.indexPathForSelectedRow!.row]
            
            vc.wikipediaTerm = favorite.label
            vc.filename = favorite.filename
        }
    }

}
