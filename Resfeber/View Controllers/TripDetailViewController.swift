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
    
    var trip: Trip
    
    // MARK: - Lifecycle
    
    init(_ trip: Trip) {
        self.trip = trip
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    // MARK: - Helpers
    
    fileprivate func configureViews() {
        view.backgroundColor = RFColor.background
    }
}
