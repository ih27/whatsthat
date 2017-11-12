//
//  PhotoIdentificationViewController.swift
//  What's That
//
//  Created by Ismayil Hasanov on 11/10/17.
//  Copyright © 2017 GWU. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class PhotoIdentificationViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    // A variable to set the source segue
    var source = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Depending on the source, request the necessary permissions
        if source == "Camera" {
            requestCameraPermissionsIfNeeded()
        } else {
            requestPhotoLibraryPermissionsIfNeeded()
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
        
        // iPad related stuff
        //imagePicker.modalPresentationStyle = .popover
        //imagePicker.popoverPresentationController?.delegate = self
        //imagePicker.popoverPresentationController?.sourceView = view
        
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
}

// Implement image picker delegate functions
extension PhotoIdentificationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        // Leave the view
        navigationController?.popViewController(animated: false)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = originalImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
