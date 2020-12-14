//
//  TripDetailViewController.swift
//  Resfeber
//
//  Created by David Wright on 12/13/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class TripDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    // MARK: - Helpers
    
    fileprivate func configureViews() {
        view.backgroundColor = RFColor.background
    }
}
