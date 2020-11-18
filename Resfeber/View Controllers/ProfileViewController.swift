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
            textFields[i].addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
            
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
    
    var profileController: ProfileController = ProfileController.shared
    var profile: Profile?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        updateViews()
    }
    
    // MARK: - Selectors
    
    @objc fileprivate func cancelProfileUpdate() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func updateProfile() {
        
        guard let profile = profileController.authenticatedUserProfile,
            let name = nameTextField.text,
            let email = emailTextField.text,
            let avatarURLString = avatarURLTextField.text,
            let avatarURL = URL(string: avatarURLString) else {
                presentSimpleAlert(with: "Some information was missing",
                                   message: "Please enter all information in, and ensure the avatar URL is in the correct format.",
                                   preferredStyle: .alert,
                                   dismissText: "Dismiss")
                return
        }
        
        profileController.updateAuthenticatedUserProfile(profile, with: name, email: email, avatarURL: avatarURL) { [weak self] (updatedProfile) in
            guard let self = self else { return }
            self.updateViews(with: updatedProfile)
        }
    }
    
    
    // MARK: - Helpers
    
    fileprivate func configureViews() {
        view.backgroundColor = UIColor.Resfeber.background
        navigationController?.navigationBar.tintColor = UIColor.Resfeber.red
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelProfileUpdate))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(updateProfile))
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
    
    private func updateViews() {
        guard let profile = profile else { return }
        updateViews(with: profile)
    }
    
    private func updateViews(with profile: Profile) {
        guard isViewLoaded else { return }
        
        if let avatarImage = profile.avatarImage {
            profileImage.setImage(avatarImage, for: .normal)
        } else if let avatarURL = profile.avatarURL {
            profileController.image(for: avatarURL, completion: { [weak self] (avatarImage) in
                guard let self = self else { return }
                
                self.profile?.avatarImage = avatarImage
                self.profileImage.setImage(avatarImage, for: .normal)
            })
        }
                
        nameTextField.text = profile.name
        emailTextField.text = profile.email
        avatarURLTextField.text = profile.avatarURL?.absoluteString
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
