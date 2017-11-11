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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestPhotoLibraryPermissionsIfNeeded()
        
        // iPad related stuff
//        imagePicker.modalPresentationStyle = .popover
//        imagePicker.popoverPresentationController?.delegate = self
//        imagePicker.popoverPresentationController?.sourceView = view
        
//        let cameraMediaType = AVMediaType.video
//        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        
        
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
//            present(imagePicker, animated: true, completion: nil)
//        }
    }
    
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
                    self.displayPermissionAlert()
                }
            })
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
    func displayPermissionAlert() {
        let message = "You need to give \"Read and Write\" access in Photos"
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
            // Original image related processing here
            imageView.image = originalImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
