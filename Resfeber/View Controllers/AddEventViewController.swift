//
//  AddEventViewController.swift
//  Resfeber
//
//  Created by David Wright on 12/22/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class AddEventViewController: UIViewController {
    
    // MARK: - Properties
    
    private let tripsController: TripsController
    private let trip: Trip
    
    private let mapView = MKMapView()

    private var nameTextField: UITextField = {
        let tf = UITextField()
        tf.textContentType = .name
        tf.placeholder = "Add an event name"
        tf.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        return tf
    }()
    
    lazy private var startDateTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Add a start date (optional)"
        startDatePicker = tf.setInputViewDatePicker(target: self, selector: #selector(tapStartDateDone))
        return tf
    }()
    
    lazy private var endDateTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Add an end date (optional)"
        endDatePicker = tf.setInputViewDatePicker(target: self, selector: #selector(tapEndDateDone))
        return tf
    }()
    
    private lazy var eventInfoStackView: UIStackView = {
        
        let sectionTitles = ["Event Name", "Start Date", "End Date"]
        let textFields = [nameTextField, startDateTextField, endDateTextField]
        
        var verticalStackSubViews = [UIView]()
        verticalStackSubViews.append(separatorView())
        
        for i in sectionTitles.indices {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            label.text = sectionTitles[i]
            label.setDimensions(width: 88)
            
            textFields[i].font = UIFont.systemFont(ofSize: 14)
            textFields[i].textColor = RFColor.red
            
            let hStack = UIStackView(arrangedSubviews: [spacer(width: 20), label, textFields[i], spacer(width: 20)])
            hStack.axis = .horizontal
            hStack.alignment = .firstBaseline
            hStack.spacing = 4
            verticalStackSubViews.append(hStack)
            verticalStackSubViews.append(separatorView())
        }
        
        let stack = UIStackView(arrangedSubviews: verticalStackSubViews)
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    private var startDatePicker = UIDatePicker()
    private var endDatePicker = UIDatePicker()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    // MARK: - Lifecycle
    
    init(trip: Trip, tripsController: TripsController) {
        self.trip = trip
        self.tripsController = tripsController
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
    
    private func configureViews() {
        view.backgroundColor = RFColor.background
        
        // Configure Navigation Bar
        navigationController?.navigationBar.tintColor = RFColor.red
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(addNewEventWasCancelled))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(newEventWasSaved))
        navigationItem.rightBarButtonItem?.isEnabled = false
        title = "New Event"
        
        // Configure MapView
        mapView.layer.borderWidth = 1
        mapView.layer.borderColor = RFColor.red.cgColor
        view.addSubview(mapView)
        mapView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                       left: view.leftAnchor,
                       right: view.rightAnchor,
                       paddingTop: 4,
                       paddingLeft: 12,
                       paddingRight: 12,
                       height: view.frame.width * 0.8)
        
        // Configure Event Info StackView
        view.addSubview(eventInfoStackView)
        eventInfoStackView.anchor(top: mapView.bottomAnchor,
                                 left: view.leftAnchor,
                                 right: view.rightAnchor,
                                 paddingTop: 16)
    }

    private func separatorView() -> UIView {
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.systemGray.withAlphaComponent(0.3)
        separatorView.setDimensions(height: 1, width: view.frame.width)
        return separatorView
    }

    private func spacer(height: CGFloat? = nil, width: CGFloat? = nil) -> UIView {
        let spacerView = UIView()

        if let width = width {
            spacerView.setDimensions(width: width)
        }

        if let width = width {
            spacerView.setDimensions(width: width)
        }
        return spacerView
    }
    
    // MARK: - Selectors
    
    @objc private func textFieldValueChanged() {
        navigationItem.rightBarButtonItem?.isEnabled = !(nameTextField.text?.isEmpty ?? true)
    }
    
    @objc func tapStartDateDone() {
        if let datePicker = self.startDateTextField.inputView as? UIDatePicker {
            self.startDateTextField.text = dateFormatter.string(from: datePicker.date)
            
            if endDateTextField.text == nil || endDateTextField.text == "" {
                endDatePicker.date = datePicker.date
            }
        }
        self.startDateTextField.resignFirstResponder()
    }

    @objc func tapEndDateDone() {
        if let datePicker = self.endDateTextField.inputView as? UIDatePicker {
            self.endDateTextField.text = dateFormatter.string(from: datePicker.date)
            
            if startDateTextField.text == nil || startDateTextField.text == "" {
                startDatePicker.date = datePicker.date
            }
        }
        self.endDateTextField.resignFirstResponder()
    }
    
    @objc func addNewEventWasCancelled() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func newEventWasSaved() {
        guard let name = nameTextField.text else { return }
        
        var startDate: Date?
        if let startDateString = startDateTextField.text {
            startDate = dateFormatter.date(from: startDateString)
        }
        
        var endDate: Date?
        if let endDateString = endDateTextField.text {
            endDate = dateFormatter.date(from: endDateString)
        }
        
        tripsController.addEvent(name: name,
                                 eventDescription: nil,
                                 category: .notSpecified,
                                 latitude: nil,
                                 longitude: nil,
                                 address: nil,
                                 startDate: startDate,
                                 endDate: endDate,
                                 notes: nil,
                                 trip: trip)
        
        self.dismiss(animated: true, completion: nil)
    }
}
