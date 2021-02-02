//
//  LoginViewController.swift
//  LabsScaffolding
//
//  Created by Spencer Curtis on 7/23/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import OktaAuth

class LoginViewController: UIViewController {
    
    lazy private var logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Logo_Combined")?.withRenderingMode(.alwaysTemplate)
        iv.contentMode = .scaleAspectFit
        iv.tintColor = RFColor.red
        return iv
    }()
    
    private var signInButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitle("Continue with Okta", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = RFColor.red
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        button.layer.cornerRadius = 12
        button.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 5
        button.layer.shouldRasterize = true
        button.layer.masksToBounds =  false
        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        NotificationCenter.default.addObserver(forName: .oktaAuthenticationSuccessful,
                                               object: nil,
                                               queue: .main,
                                               using: checkForExistingProfile)
        
        NotificationCenter.default.addObserver(forName: .oktaAuthenticationExpired,
                                               object: nil,
                                               queue: .main,
                                               using: alertUserOfExpiredCredentials)
        
    }
    
    // MARK: - Actions
    
    @IBAction func signIn(_ sender: Any) {
        UIApplication.shared.open(ProfileController.shared.oktaAuth.identityAuthURL()!)
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        view.backgroundColor = RFColor.background
        view.addSubview(logoImageView)
        logoImageView.setDimensions(height: 128)
        logoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             left: view.safeAreaLayoutGuide.leftAnchor,
                             right: view.safeAreaLayoutGuide.rightAnchor,
                             paddingLeft: 67,
                             paddingRight: 67)
        
        view.addSubview(signInButton)
        signInButton.setDimensions(height: 50, width: 280)
        signInButton.centerX(inView: view)
        signInButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 120)
    }
    
    private func alertUserOfExpiredCredentials(_ notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.presentSimpleAlert(with: "Your Okta credentials have expired",
                           message: "Please sign in again",
                           preferredStyle: .alert,
                           dismissText: "Dimiss")
        }
    }
    
    // MARK: Notification Handling
    
    private func checkForExistingProfile(with notification: Notification) {
        print("\tNotificationCenter.oktaAuthenticationSuccessful (LoginViewController)")
        checkForExistingProfile()
    }
    
    private func checkForExistingProfile() {
        print("LoginViewController.checkForExistingProfile()")
        ProfileController.shared.checkForExistingAuthenticatedUserProfile { [weak self] exists in
            
            guard let self = self, self.presentedViewController == nil else { return }
            
            if exists {
                self.navigationController?.dismiss(animated: true, completion: nil)
            } else {
                self.performSegue(withIdentifier: "ModalAddProfile", sender: nil)
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ModalAddProfile" {
            guard let addProfileVC = segue.destination as? AddProfileViewController else { return }
            addProfileVC.delegate = self
        }
    }
}

// MARK: - Add Profile Delegate

extension LoginViewController: AddProfileDelegate {
    func profileWasAdded() {
        checkForExistingProfile()
    }
}
