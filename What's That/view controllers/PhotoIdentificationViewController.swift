//
//  PhotoIdentificationViewController.swift
//  What's That
//
//  Created by Ismayil Hasanov on 11/10/17.
//  Copyright © 2017 GWU. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoIdentificationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the image picker
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        // iPad related stuff
//        imagePicker.modalPresentationStyle = .popover
//        imagePicker.popoverPresentationController?.delegate = self
//        imagePicker.popoverPresentationController?.sourceView = view
        
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        switch cameraAuthorizationStatus {
            case .authorized:
                // Access is granted by user.
                print("authorized")
                break
            
            case .notDetermined:
                // It is not determined until now.
                print("not determined")
                break
            
            case .restricted:
                // User do not have access to camera.
                print("user has no access")
                break
            
            case .denied:
                // User has denied the permission.
                print("user has denied an access")
                break
        }
        
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
//            present(imagePicker, animated: true, completion: nil)
//        }
    }
}

// Implement image picker delegate functions
extension PhotoIdentificationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            // Edited image related processing here
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // Original image related processing here
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
