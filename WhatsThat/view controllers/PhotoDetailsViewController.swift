//
//  PhotoDetailsViewController.swift
//  WhatsThat
//
//  Created by Ismayil Hasanov on 11/15/17.
//  Copyright © 2017 GWU. All rights reserved.
//

import UIKit
import SafariServices
import TwitterKit
import MBProgressHUD

class PhotoDetailsViewController: UIViewController {
    
    // Interface Builder outlets
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var wikiExtractTextView: UITextView!
    @IBOutlet weak var wikiButton: UIButton!
    @IBOutlet weak var tweetsButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    // Favorite button related variables
    var isFavorite = false
    var iconName = "heart"
    
    // The term passed from PhotoIdentification view
    var wikipediaTerm = ""
    var wikipediaPageUrl = "https://en.wikipedia.org/?curid="
    
    // The photo passed from PhotoIdentification view (in case if needed for the favorite thumbnail
    var filename: URL?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Set the label text
        idLabel.text = wikipediaTerm.capitalized
        
        // Start a spinner
        MBProgressHUD.showAdded(to: self.wikiExtractTextView, animated: true)
        
        // Get the Wikipedia APi results
        fetchResults(for: wikipediaTerm)        
        
        // Change the icon based on if it is a favorite
        DispatchQueue.main.async {
            self.isFavorite = Persistance.sharedInstance.doFavoritesContain(self.wikipediaTerm, self.filename!)
            if self.isFavorite {
                self.iconName = "heart-filled"
            }
            
            // Set the favorite button
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: self.iconName), style: .plain, target: self, action: #selector(self.favoriteTapped))
        }
    }
    
    // Toggle for favorite button
    @objc func favoriteTapped() {
        if let filename = filename {
            if isFavorite {
                isFavorite = false
                iconName = "heart"
                // print("unfavorite")
                deleteFavorite(with: filename)
            } else {
                isFavorite = true
                iconName = "heart-filled"
                // print("favorite")
                saveFavorite(with: filename)
            }
        }
        
        // Set the new image for the favorite button
        navigationItem.rightBarButtonItem?.image = UIImage(named: iconName)
    }
    
    // Save the current label and its associated image filename as a favorite
    func saveFavorite(with filename: URL) {
        Persistance.sharedInstance.saveIdentification(wikipediaTerm, filename)
    }
    
    // Delete the current label and its associated image from favorites list
    func deleteFavorite(with filename: URL) {
        Persistance.sharedInstance.deleteIdentification(wikipediaTerm, filename)
    }
    
    @IBAction func wikiButtonTapped(_ sender: UIButton) {
        
        if let url = URL(string: wikipediaPageUrl) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            // Change the control button colors to match the app theme
            vc.preferredControlTintColor = UIColor.orange
            present(vc, animated: true)
        }
    }
    
    @IBAction func tweetsButtonTapped(_ sender: UIButton) {
        
        let vc = SearchTimelineViewController()
        vc.twitterQuery = wikipediaTerm
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        
        let shareText = wikiExtractTextView?.text
        
        // Get the image from the directory to share
        guard let filename = filename else {
            return
        }
        
        let shareImage = UIImage(contentsOfFile: filename.path)!
        
        if let shareText = shareText {
            let vc = UIActivityViewController(activityItems: [shareText, shareImage], applicationActivities: [])
            present(vc, animated: true)
        }
    }
    
    // Fetch results with the help of WikipediaAPIManager
    private func fetchResults(for query: String) {
        
        let manager = WikipediaAPIManager()
        manager.delegate = self
        manager.fetchExtract(for: query)
    }
}

// Implement WikipediaAPIManager delegate functions
extension PhotoDetailsViewController: WikipediaDelegate {
    func resultFound(_ result: WikipediaResult?) {
        
        guard let infoText = result?.extract, let pageid = result?.pageid else {
            return
        }
        
        // Set the Wiki page URL
        self.wikipediaPageUrl += String(pageid)
        
        // Convert to HTML text with the help String extension function
        let attributedText = infoText.convertHtml()
        
        // Run in the main thread
        DispatchQueue.main.async {
            // Change the text and button states (since the info is available for buttons)
            self.wikiExtractTextView.attributedText = attributedText
            self.wikiButton.isEnabled = true
            self.tweetsButton.isEnabled = true
            self.shareButton.isEnabled = true
            
            // Stop the spinner
            MBProgressHUD.hide(for: self.wikiExtractTextView, animated: true)
        }
    }
    
    func resultNotFound() {
        
        print("no API results :(")
    }
}
