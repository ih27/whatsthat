//
//  SearchTimelineViewController.swift
//  WhatsThat
//
//  Created by Ismayil Hasanov on 11/19/17.
//  Copyright © 2017 GWU. All rights reserved.
//

import UIKit
import TwitterKit

class SearchTimelineViewController: TWTRTimelineViewController {
    
    var twitterQuery = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Tweets with '\(twitterQuery)'"
        
        let dataSource = TWTRSearchTimelineDataSource(searchQuery: twitterQuery+" filter:media", apiClient: TWTRAPIClient())
        
        // Return only the most popular results in the response.
        dataSource.resultType = "popular"
        
        // Show Tweet actions
        self.showTweetActions = true
        
        self.dataSource = dataSource        
    }
}
