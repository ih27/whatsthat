//
//  PhotoDetailsViewController.swift
//  WhatsThat
//
//  Created by Ismayil Hasanov on 11/15/17.
//  Copyright © 2017 GWU. All rights reserved.
//

import UIKit
import SafariServices

class PhotoDetailsViewController: UIViewController {
    
    // Interface Builder outlets
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var wikiExtractTextView: UITextView!
    @IBOutlet weak var wikiButton: UIButton!
    @IBOutlet weak var tweetsButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    // Favorite button related variables
    var favoritePressed = false
    var iconName = "heart"
    
    // The term passed from PhotoIdentification view
    var wikipediaTerm = ""
    var wikipediaPageUrl = "https://en.wikipedia.org/?curid="
    
    // The photo passed from PhotoIdentification view (in case if needed for the favorite thumbnail
    var photo: UIImage?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Set the label text
        idLabel.text = wikipediaTerm.capitalized
        
        // Get the Wikipedia APi results
        fetchResults(for: wikipediaTerm)
        
        // Add favorite button to the navigation bar
        if favoritePressed {
            iconName = "heart-filled"
        }
        
        // Set the favorite button
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
    
    @IBAction func wikiButtonTapped(_ sender: UIButton) {
        
        if let url = URL(string: wikipediaPageUrl) {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        let shareText = wikiExtractTextView?.text
        let shareImage = photo
        
        if let shareText = shareText, let shareImage = shareImage {
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
        }
    }
    
    func resultNotFound() {
        
        print("no API results :(")
    }
    
    
}
