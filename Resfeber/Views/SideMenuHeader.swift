//
//  SideMenuHeader.swift
//  Resfeber
//
//  Created by David Wright on 11/17/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

protocol SideMenuHeaderDelegate: class {
    func didTapProfileImage()
}

class SideMenuHeader: UIView {
    
    // MARK: - Properties
    
    var profile: Profile? {
        didSet {
            updateViews()
        }
    }
    
    weak var delegate: SideMenuHeaderDelegate?
    
    private let profileImage: UIButton = {
        let diameter: CGFloat = 64
        let button = UIButton(type: .custom)
        button.setDimensions(height: diameter, width: diameter)
        button.layer.cornerRadius = diameter / 2
        button.layer.masksToBounds = true
        button.backgroundColor = .white
        button.tintColor = .systemGray
        button.addTarget(self, action: #selector(didTapProfileImage), for: .touchUpInside)
        return button
    }()
    
    private let placeholderProfileImage: UIImage? = {
        let buttonDiameter: CGFloat = 64
        let config = UIImage.SymbolConfiguration(pointSize: buttonDiameter + 1)
        let image = UIImage(systemName: "person.crop.circle.fill")?.withConfiguration(config)
        return image
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = RFColor.light
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = RFColor.light.withAlphaComponent(0.85)
        return label
    }()
    
    // MARK: - Lifecycle
    
    init(profile: Profile?, frame: CGRect) {
        self.profile = profile
        super.init(frame: frame)
        
        configureViews()
        updateViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func didTapProfileImage() {
        delegate?.didTapProfileImage()
    }
    
    // MARK: - Helper Functions
    
    private func configureViews() {
        backgroundColor = RFColor.sideMenuBackground
        
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
    
    private func updateViews() {
        if let image = profile?.avatarImage {
            profileImage.imageView?.contentMode = .scaleAspectFill
            profileImage.setImage(image, for: .normal)
        } else {
            profileImage.imageView?.contentMode = .center
            profileImage.setImage(placeholderProfileImage, for: .normal)
        }
        
        nameLabel.text = profile?.name ?? "Unknown User"
        emailLabel.text = profile?.email ?? ""
    }
}
