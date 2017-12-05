//
//  PhotoIdentificationViewController.swift
//  WhatsThat
//
//  Created by Ismayil Hasanov on 11/10/17.
//  Copyright © 2017 GWU. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import MBProgressHUD

class PhotoIdentificationViewController: UIViewController {
    
    // Interface Builder outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    let manager = GoogleVisionAPIManager()
    var results = [GoogleVisionLabel]()
    
    let locationFinder = LocationFinder()
    var currentLatitude: CLLocationDegrees?
    var currentLongitude: CLLocationDegrees?
    
    var label: String?
    var source: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the Google Vision API delegate
        manager.delegate = self
        
        // Set the LocationFinder delegate
        locationFinder.delegate = self
        // Request location info too for favorites
        locationFinder.findLocation()
        
        // Set the necessary properties for the table view
        tableView.delegate = self
        tableView.dataSource = self
        
        // Depending on the source, request the necessary permissions
        if source == Constants.cameraSource {
            requestCameraPermissionsIfNeeded()
        } else if source == Constants.photoLibrarySource {
            requestPhotoLibraryPermissionsIfNeeded()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Constants.photoDetailsId) {
            let vc = segue.destination as! PhotoDetailsViewController
            vc.wikipediaTerm = label ?? ""
            vc.photoLatitude = currentLatitude
            vc.photoLongitude = currentLongitude
            
            // Save the image and pass the filename
            if let data = UIImageJPEGRepresentation(imageView.image ?? UIImage(), Constants.compressionQuality) {
                // Create a unique filename
                let filename = getDocumentsDirectory().appendingPathComponent(UUID().uuidString)
                try? data.write(to: filename)
                vc.filename = filename
            }
        }
    }
    
    // Camera access request
    private func requestCameraPermissionsIfNeeded() {
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        if cameraAuthorizationStatus == .authorized {
            // Access is granted by user
            snapPhoto()
        } else {
            // Access is still not granted
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                if response {
                    // Access is granted by user
                    self.snapPhoto()
                } else {
                    // User needs to be directed to the app settings
                    self.displayPermissionAlert(with: Constants.cameraPermissionsErrorMessage)
                }
            }
        }
    }
    
    // Photo library permissions request
    private func requestPhotoLibraryPermissionsIfNeeded() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if photoAuthorizationStatus == .authorized {
            // Access is granted by user
            selectPhotoFromLibrary()
        } else {
            // Access is still not granted
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                    // Access is granted by user
                    self.selectPhotoFromLibrary()
                } else {
                    // User needs to be directed to the app settings
                    self.displayPermissionAlert(with: Constants.photoLibraryPermissionsErrorMessage)
                }
            })
        }
    }
    
    // Present the camera image picker to snap a photo
    // The location is needed for the favorites map
    private func snapPhoto() {
        
        // Set the camera image picker
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        
        // Make sure the camera is available
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // Present the photo library image picker to select an image
    private func selectPhotoFromLibrary() {
        // Set the photo library image picker
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
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
    
    // Fetch results with the help of GoogleVisionAPIManager
    private func fetchResults(for image: UIImage) {
        
        // Start a spinner
        let spinner = MBProgressHUD.showAdded(to: self.tableView, animated: true)
        spinner.label.text = Constants.spinnerLabelText
        spinner.contentColor = Constants.themeColor
        
        manager.fetchIdentifications(for: image)
    }
}

// Implement image picker delegate functions
extension PhotoIdentificationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Cancel button tapped
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        // Leave the view
        navigationController?.popViewController(animated: false)
    }
    
    // Image chosen
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = originalImage
            fetchResults(for: originalImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

// Implement table view delegate functions
extension PhotoIdentificationViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Number of rows in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return results.count
    }
    
    // Set the preperties for each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.identifiedObjectCellId, for: indexPath)
        let label = results[indexPath.row]
        
        // Cell title
        cell.textLabel?.text = "\(label.description)"
        
        // Cell subtitle
        cell.detailTextLabel?.text = "Confidence: \(String(format: "%.2f%%", label.score * 100))"
        cell.detailTextLabel?.textColor = UIColor.gray
        
        return cell
    }
    
    // Set the wikipedia label and go to the details view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        label = cell?.textLabel?.text ?? ""
        
        performSegue(withIdentifier: Constants.photoDetailsId, sender: self)
    }
}

// Implement GoogleVisionAPIManager delegate functions
extension PhotoIdentificationViewController: GoogleVisionDelegate {
    func resultsFound(_ results: [GoogleVisionLabel]) {
        
        // Results sorted by confidence scores
        self.results = results
        
        // Run in the main thread
        DispatchQueue.main.async {
            self.tableView.reloadData()
            // Stop the spinner
            MBProgressHUD.hide(for: self.tableView, animated: true)
        }
    }
    
    func resultsNotFound(reason: GoogleVisionAPIManager.FailureReason) {
        
        // Run in the main thread
        DispatchQueue.main.async {
            // Stop the spinner
            MBProgressHUD.hide(for: self.tableView, animated: true)
            
            let ac = UIAlertController(title: self.title, message: reason.rawValue, preferredStyle: .alert)
            
            switch reason {
            case .networkRequestFailed:
                let retryAction = UIAlertAction(title: Constants.retryButtonTitle, style: .default, handler: { action in
                    self.fetchResults(for: self.imageView.image ?? UIImage())
                })
                
                // Cancel button action
                let cancelAction = UIAlertAction(title: Constants.cancelButtonTitle, style: .default){ action in
                    self.navigationController?.popViewController(animated: true)
                }
                
                ac.addAction(retryAction)
                ac.addAction(cancelAction)
                
            case .badJSONResponse, .noLabelFound:                
                // OK button action
                let okAction = UIAlertAction(title: Constants.okButtonTitle, style: .default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                })
                
                ac.addAction(okAction)
            }
            
            // Present the alert
            self.present(ac, animated: true)
        }
    }
}

// Implement LocationFinder delegate functions
extension PhotoIdentificationViewController: LocationFinderDelegate {
    func locationFound(latitude: Double, longitude: Double) {
        // Save the coordinates
        currentLatitude = latitude
        currentLongitude = longitude
    }
    
    func locationNotFound(reason: LocationFinder.FailureReason) {
        // Run in the main thread
        DispatchQueue.main.async {
            
            let ac = UIAlertController(title: self.title, message: reason.rawValue, preferredStyle: .alert)
            
            switch reason {
            case .generic, .timeout:
                
                // Cancel button action
                let cancelAction = UIAlertAction(title: Constants.cancelButtonTitle, style: .default)
                
                ac.addAction(cancelAction)
                
            case .noPermission:
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
                }
                
                // OK button action
                let okAction = UIAlertAction(title: Constants.okButtonTitle, style: .default)
                
                ac.addAction(settingsAction)
                ac.addAction(okAction)
            }
            
            // Present the alert
            self.present(ac, animated: true)
        }
    }
}

// Helper function to locate the documents directory
extension PhotoIdentificationViewController {
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
