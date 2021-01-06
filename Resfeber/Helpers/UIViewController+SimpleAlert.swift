//
//  UIViewController+SimpleAlert.swift
//  labs-ios-starter
//
//  Created by Spencer Curtis on 7/30/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentSimpleAlert(with title: String?,
                            message: String?,
                            preferredStyle: UIAlertController.Style,
                            dismissText: String,
                            completionUponDismissal: ((UIAlertAction) -> Void)? = nil)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)

        let dismissAction = UIAlertAction(title: dismissText, style: .cancel, handler: completionUponDismissal)
        alert.addAction(dismissAction)

        present(alert, animated: true, completion: nil)
    }
    
    func presentDeletionAlert(title: String?,
                              message: String?,
                              preferredStyle: UIAlertController.Style = .alert,
                              completionUponDeletion: ((UIAlertAction) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alert.view.tintColor = RFColor.red
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: completionUponDeletion)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true, completion: nil)
    }
}
