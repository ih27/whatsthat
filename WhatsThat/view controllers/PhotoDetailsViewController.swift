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
    
    let manager = WikipediaAPIManager()
    
    // Favorite button related variables
    var isFavorite = false
    var iconName = Constants.favoriteImageName
    
    // The term passed from PhotoIdentification view
    var wikipediaTerm = ""
    var wikipediaPageUrl = Constants.wikipediaPageUrl
    
    // The photo passed from PhotoIdentification view (in case if needed for the favorite thumbnail
    var filename: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the Wikipedia API delegate
        manager.delegate = self
        
        // Set the label text
        idLabel.text = wikipediaTerm.capitalized
        
        // Start a spinner
        let spinner = MBProgressHUD.showAdded(to: self.wikiExtractTextView, animated: true)
        spinner.label.text = Constants.spinnerLabelText
        spinner.contentColor = Constants.themeColor
        
        // Get the Wikipedia APi results
        fetchResults(for: wikipediaTerm)        
        
        // Change the icon based on if it is a favorite
        DispatchQueue.main.async {
            self.isFavorite = Persistance.sharedInstance.doFavoritesContain(self.wikipediaTerm, self.filename!)
            if self.isFavorite {
                self.iconName = Constants.favoriteFilledImageName
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
                iconName = Constants.favoriteImageName
                deleteFavorite(with: filename)
            } else {
                isFavorite = true
                iconName = Constants.favoriteFilledImageName
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
        
        manager.fetchExtract(for: query)
    }
}

// Implement WikipediaAPIManager delegate functions
extension PhotoDetailsViewController: WikipediaDelegate {
    func resultFound(_ result: WikipediaResult) {
        
        guard let pageid = result.pageid else {
            return
        }
        
        // Set the Wiki page URL
        self.wikipediaPageUrl += String(pageid)
        
        // Convert to HTML text with the help String extension function
        let attributedText = result.extract?.convertHtml()
        
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
    
    func resultNotFound(reason: WikipediaAPIManager.FailureReason) {
        
        // Run in the main thread
        DispatchQueue.main.async {
            // Stop the spinner
            MBProgressHUD.hide(for: self.wikiExtractTextView, animated: true)
            
            let ac = UIAlertController(title: self.title, message: reason.rawValue, preferredStyle: .alert)
            
            switch reason {
            case .networkRequestFailed:
                let retryAction = UIAlertAction(title: Constants.retryButtonTitle, style: .default, handler: { action in
                    self.fetchResults(for: self.wikipediaTerm)
                })
                
                // Cancel button action
                let cancelAction = UIAlertAction(title: Constants.cancelButtonTitle, style: .default){ action in
                    self.navigationController?.popViewController(animated: true)
                }
                
                ac.addAction(retryAction)
                ac.addAction(cancelAction)
                
            case .badJSONResponse:
                // OK button action
                let okAction = UIAlertAction(title: Constants.okButtonTitle, style: .default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                })
                
                ac.addAction(okAction)
            
            case .noExtractFound:
                // OK button action
                let okAction = UIAlertAction(title: Constants.okButtonTitle, style: .default, handler: { action in
                    self.wikiExtractTextView.text = Constants.wikiNoExtractText
                })
                
                ac.addAction(okAction)
            }
            // Present the alert
            self.present(ac, animated: true)
        }
    }
}
