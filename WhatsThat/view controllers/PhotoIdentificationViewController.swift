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

class PhotoIdentificationViewController: UIViewController {
    
    // Interface Builder outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    // A variable to hold Google Vision API results
    var results = [GoogleVisionLabel]()
    
    // A variable to pass to Wikipedia API
    var label = ""
    
    // A variable to set the source segue
    var source = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the necessary delegates for the table view
        tableView.delegate = self
        tableView.dataSource = self
        
        // Depending on the source, request the necessary permissions
        if source == "Camera" {
            requestCameraPermissionsIfNeeded()
        } else {
            requestPhotoLibraryPermissionsIfNeeded()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "PhotoDetails") {
            let vc = segue.destination as! PhotoDetailsViewController
            vc.wikipediaTerm = label
            vc.photo = imageView.image!
        }
    }
    
    // Camera access request
    func requestCameraPermissionsIfNeeded() {
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
                    // User need to be directed to the app settings
                    let message = "You need to turn the Camera access on"
                    self.displayPermissionAlert(with: message)
                }
            }
        }
    }
    
    // Photo library permissions request
    func requestPhotoLibraryPermissionsIfNeeded() {
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
                    // User need to be directed to the app settings
                    let message = "You need to give \"Read and Write\" access in Photos"
                    self.displayPermissionAlert(with: message)
                }
            })
        }
    }
    
    // Present the camera image picker to snap a photo
    func snapPhoto() {
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
    func selectPhotoFromLibrary() {
        // Set the photo library image picker
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Display an alert trying to direct users to Settings
    func displayPermissionAlert(with message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Setting button action
        let settingsAction = UIAlertAction(title: "Go to Settings", style: .default) { action in
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
        let cancelAction = UIAlertAction(title: "Cancel", style: .default){ action in
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
        let manager = GoogleVisionAPIManager()
        manager.delegate = self
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
    
    // Disable the section header by setting the height to minimum
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return CGFloat.leastNormalMagnitude
    }
    
    // Number of rows in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return results.count
    }
    
    // Set the preperties for each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifiedObjectCell", for: indexPath)
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
        
        performSegue(withIdentifier: "PhotoDetails", sender: self)
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
        }
    }
    
    func resultsNotFound() {
        print("no API results :(")
    }
}
