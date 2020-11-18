//
//  SideMenuHeader.swift
//  Resfeber
//
//  Created by David Wright on 11/17/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class SideMenuHeader: UIView {
    
    // MARK: - Properties
    
    private let profile: Profile
    
    fileprivate let profileImage: UIButton = {
        let diameter: CGFloat = 64
        let button = UIButton()
        button.isUserInteractionEnabled = false
        button.setDimensions(height: diameter, width: diameter)
        button.layer.cornerRadius = diameter / 2
        button.layer.masksToBounds = true
        button.contentMode = .scaleAspectFill
        button.backgroundColor = .systemGray3

        let config = UIImage.SymbolConfiguration(pointSize: diameter * 0.8)
        let placeholderImage = UIImage(systemName: "person.fill")?
            .withConfiguration(config)
            .withTintColor(.systemGray6, renderingMode: .alwaysOriginal)
        
        button.setImage(placeholderImage, for: .normal)
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.Resfeber.light
        label.text = profile.name
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.Resfeber.light.withAlphaComponent(0.85)
        label.text = profile.email
        return label
    }()
    
    // MARK: - Lifecycle
    
    init(profile: Profile, frame: CGRect) {
        self.profile = profile
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Functions
    
    fileprivate func configureViews() {
        backgroundColor = UIColor.Resfeber.red
        
        addSubview(profileImage)
        profileImage.anchor(top: topAnchor, left: leftAnchor, paddingTop: 4, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [nameLabel, emailLabel])
        stack.distribution = .fillEqually
        stack.spacing = 4
        stack.axis = .vertical
        
        addSubview(stack)
        stack.centerY(inView: profileImage)
        stack.anchor(left: profileImage.rightAnchor, paddingLeft: 12)
    }
}
