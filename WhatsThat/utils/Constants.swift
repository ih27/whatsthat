//
//  Constants.swift
//  WhatsThat
//
//  Created by Ismayil Hasanov on 11/25/17.
//  Copyright © 2017 GWU. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let themeColor: UIColor = .orange
    
    static let photoIdentificationId = "photoIdentification"
    static let photoDetailsId = "photoDetails"
    static let identifiedObjectCellId = "identifiedObjectCell"
    static let favoriteCellId = "favoriteCell"
    
    static let cameraOrPhotoAlbumButtonAlertTitle = "Choose the image source:"
    static let settingsButtonAlertTitle = "Go to Settings"
    static let cancelButtonTitle = "Cancel"
    
    static let cameraImageName = "camera"
    static let photoLibraryImageName = "photo-library"
    static let favoriteImageName = "heart"
    static let favoriteFilledImageName = "heart-filled"
    
    static let cameraSource = "Camera"
    static let photoLibrarySource = "Photo Library"
    
    static let compressionQuality: CGFloat = 0.7
    
    static let cameraPermissionsErrorMessage = "You need to turn the Camera access on"
    static let photoLibraryPermissionsErrorMessage = "You need to give \"Read and Write\" access in Photos"
    
    static let wikipediaPageUrl = "https://en.wikipedia.org/?curid="
    
    static let twitterKey = "Zct4IihPMR8S3MOWmzVt7DDge"
    static let twitterSecret = "BTQYjbwBL99Rx6VRrNL4wQ6jkxYksqh6ZIaRZji26hIKjEGox6"
    static let twitterResultType = "popular"
    static let twitterQueryFilter = " filter:media"
}
