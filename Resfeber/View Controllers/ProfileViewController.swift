//
//  ProfileViewController.swift
//  Resfeber
//
//  Created by David Wright on 11/17/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    fileprivate let profileImage: UIButton = {
        let diameter: CGFloat = 150
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
        
    fileprivate var nameTextField = UITextField()
    fileprivate var emailTextField = UITextField()
    fileprivate var avatarURLTextField = UITextField()
    
    fileprivate lazy var profileInfoStackView: UIStackView = {
        
        let sectionTitles = ["Name", "Email", "Avatar URL"]
        let textFields = [nameTextField, emailTextField, avatarURLTextField]
        
        var verticalStackSubViews = [UIView]()
        verticalStackSubViews.append(seperatorView())
        
        for i in sectionTitles.indices {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 14)
            label.text = sectionTitles[i]
            label.setDimensions(width: 86)
            
            textFields[i].font = UIFont.systemFont(ofSize: 14)
            textFields[i].textColor = UIColor.Resfeber.red
            
            let hStack = UIStackView(arrangedSubviews: [spacer(width: 20), label, textFields[i], spacer(width: 20)])
            hStack.axis = .horizontal
            hStack.alignment = .firstBaseline
            hStack.spacing = 4
            verticalStackSubViews.append(hStack)
            verticalStackSubViews.append(seperatorView())
        }
        
        let stack = UIStackView(arrangedSubviews: verticalStackSubViews)
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
    }
    
    // MARK: - Selectors
    
    
    // MARK: - Helpers
    
    fileprivate func configureViews() {
        view.backgroundColor = UIColor.Resfeber.background
        navigationController?.navigationBar.tintColor = UIColor.Resfeber.red
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        title = "Edit Profile"
        
        view.addSubview(profileImage)
        profileImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 36)
        profileImage.centerX(inView: view)
        
        view.addSubview(profileInfoStackView)
        profileInfoStackView.anchor(top: profileImage.bottomAnchor,
                                    left: view.leftAnchor,
                                    right: view.rightAnchor,
                                    paddingTop: 36)
    }
    
    
    fileprivate func seperatorView() -> UIView {
        let seperatorView = UIView()
        seperatorView.backgroundColor = UIColor.systemGray.withAlphaComponent(0.3)
        seperatorView.setDimensions(height: 1, width: view.frame.width)
        return seperatorView
    }
    
    fileprivate func spacer(height: CGFloat? = nil, width: CGFloat? = nil) -> UIView {
        let spacerView = UIView()
        
        if let width = width {
            spacerView.setDimensions(width: width)
        }
        
        if let width = width {
            spacerView.setDimensions(width: width)
        }
        
        return spacerView
    }
}
