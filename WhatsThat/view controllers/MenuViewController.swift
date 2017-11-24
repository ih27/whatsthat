//
//  ViewController.swift
//  WhatsThat
//
//  Created by Ismayil Hasanov on 11/6/17.
//  Copyright © 2017 GWU. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cameraOrPhotoAlbumButtonTapped(_ sender: UIButton) {
        // Instantiate the storyboard and the PhotoIdentification VC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let photoIdentificationVc = storyboard.instantiateViewController(withIdentifier: "photoIdentification") as! PhotoIdentificationViewController
        
        // Create an action sheet alert controller
        let alertController = UIAlertController(title: "Choose the image source:", message: nil, preferredStyle: .actionSheet)
        
        // Create camera button
        let cameraButton = UIAlertAction(title: "Camera", style: .default, handler: { action in
            
            photoIdentificationVc.source = "Camera"
            self.navigationController?.show(photoIdentificationVc, sender: self)
        })
        
        // Create photo library button
        let photoLibraryButton = UIAlertAction(title: "Photo Library", style: .default, handler: { action in
            
            photoIdentificationVc.source = "Photo Library"
            self.navigationController?.show(photoIdentificationVc, sender: self)
        })
        
        // Create cancel button
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Add the buttons to the alert controller
        alertController.addAction(cameraButton)
        alertController.addAction(photoLibraryButton)
        alertController.addAction(cancelButton)
        
        // Show the action sheet
        navigationController?.present(alertController, animated: true)
    }
}

