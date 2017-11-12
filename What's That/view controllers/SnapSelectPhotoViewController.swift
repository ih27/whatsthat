//
//  PopoverViewController.swift
//  What's That
//
//  Created by Ismayil Hasanov on 11/8/17.
//  Copyright © 2017 GWU. All rights reserved.
//

import UIKit

class SnapSelectPhotoViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PhotoIdentificationViewController
        // Only two possible segues, and both have an identifier
        vc.source = segue.identifier!
    }
}
