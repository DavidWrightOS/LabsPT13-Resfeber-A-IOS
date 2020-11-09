//
//  ExploreViewController.swift
//  Resfeber
//
//  Created by David Wright on 11/8/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController {
    
    // MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        label.text = "Explore"
        return label
    }()
    
    private let profileButton: UIButton = {
        let button = UIButton(type: .system)
        let buttonDiameter: CGFloat = 32
        button.setDimensions(height: buttonDiameter, width: buttonDiameter)
        button.layer.cornerRadius = buttonDiameter / 2
        button.layer.masksToBounds = true
        button.contentMode = .scaleAspectFill
        button.backgroundColor = .systemGray3
        button.addTarget(self, action: #selector(profileImageTapped), for: .touchUpInside)
        
        let image = UIImage(systemName: "person.fill")!.withTintColor(.systemGray6, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        
        return button
    }()
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    // MARK: - Selectors
    
    @objc fileprivate func profileImageTapped() {
        print("DEBUG: profileImageTapped..")
    }
    
    // MARK: - Helpers
    
    fileprivate func configureViews() {
        view.backgroundColor = UIColor.Resfeber.background
        navigationController?.navigationBar.isHidden = true
        
        // Configure Title Label
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                          right: view.rightAnchor, paddingTop: 4, paddingLeft: 20, paddingRight: 20)
        
        // Configure Profile Button
        view.addSubview(profileButton)
        profileButton.anchor(right: view.rightAnchor, paddingRight: 20)
        profileButton.centerY(inView: titleLabel)
    }
}
