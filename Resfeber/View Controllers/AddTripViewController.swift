//
//  AddTripViewController.swift
//  Resfeber
//
//  Created by Joshua Rutkowski on 12/5/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddTripViewController: UIViewController {
    
    // MARK: - Properties
    var tripService: TripService!
    var coreDataStack = CoreDataStack()
    
    fileprivate let tripImage: UIButton = {
        let diameter: CGFloat = 150
        let button = UIButton()
        button.isUserInteractionEnabled = false
        button.setDimensions(height: diameter, width: diameter * 1.5)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.contentMode = .scaleAspectFill
        button.backgroundColor = .systemGray3

        let config = UIImage.SymbolConfiguration(pointSize: diameter * 0.8)
        let placeholderImage = UIImage(systemName: "photo.fill")?
            .withConfiguration(config)
            .withTintColor(.systemGray6, renderingMode: .alwaysOriginal)
        
        button.setImage(placeholderImage, for: .normal)
        return button
    }()
        
    fileprivate var nameTextField = UITextField()
    fileprivate var startDateTextField = UITextField()
    fileprivate var endDateTextField = UITextField()
    
    fileprivate lazy var tripInfoStackView: UIStackView = {
        
        let sectionTitles = ["Trip Name", "Start Date", "End Date"]
        let textFields = [nameTextField, startDateTextField, endDateTextField]
        
        var verticalStackSubViews = [UIView]()
        verticalStackSubViews.append(seperatorView())
        
        for i in sectionTitles.indices {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 14)
            label.text = sectionTitles[i]
            label.setDimensions(width: 86)
            
            textFields[i].font = UIFont.systemFont(ofSize: 14)
            textFields[i].textColor = RFColor.red
            startDateTextField.setInputViewDatePicker(target: self, selector: #selector(tapStartDateDone))
            endDateTextField.setInputViewDatePicker(target: self, selector: #selector(tapEndDateDone))
            
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
        
        tripService = TripService(managedObjectContext: coreDataStack.mainContext,
                                  coreDataStack: coreDataStack)
    }

    // MARK: - Helpers
    
    fileprivate func configureViews() {
        view.backgroundColor = RFColor.background
        navigationController?.navigationBar.tintColor = RFColor.red
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(addNewTripWasCancelled))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(newTripWasSaved))
        navigationItem.rightBarButtonItem?.isEnabled = true
        title = "Add New Trip"
        
        view.addSubview(tripImage)
        tripImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 36)
        tripImage.centerX(inView: view)
        
        view.addSubview(tripInfoStackView)
        tripInfoStackView.anchor(top: tripImage.bottomAnchor,
                                    left: view.leftAnchor,
                                    right: view.rightAnchor,
                                    paddingTop: 36)
    }
    
    @objc func addNewTripWasCancelled() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func newTripWasSaved() {
        let trip = tripService.addTrip(name: nameTextField.text ?? "",
                                   image: nil,
                                   startDate: nil,
                                   endDate: nil)
        print("Trip was created: \(trip)")
        
        NotificationCenter.default.post(name: NSNotification.Name("load"), object: nil)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func tapStartDateDone() {
        if let datePicker = self.startDateTextField.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .medium
            self.startDateTextField.text = dateformatter.string(from: datePicker.date)
        }
        self.startDateTextField.resignFirstResponder()
    }
    
    @objc func tapEndDateDone() {
        if let datePicker = self.endDateTextField.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .medium
            self.endDateTextField.text = dateformatter.string(from: datePicker.date)
        }
        self.endDateTextField.resignFirstResponder()
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
