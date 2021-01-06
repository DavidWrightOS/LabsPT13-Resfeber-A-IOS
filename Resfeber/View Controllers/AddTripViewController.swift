//
//  AddTripViewController.swift
//  Resfeber
//
//  Created by Joshua Rutkowski on 12/5/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import PhotosUI

protocol AddTripViewControllerDelegate: class {
    func didAddNewTrip(_ trip: Trip)
    func didUpdateTrip(_ trip: Trip)
}

extension AddTripViewControllerDelegate {
    func didAddNewTrip(_ trip: Trip) {}
    func didUpdateTrip(_ trip: Trip) {}
}

class AddTripViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    weak var delegate: AddTripViewControllerDelegate?
    
    private let tripsController: TripsController
    
    var trip: Trip? {
        didSet {
            updateViews()
        }
    }
    
    var imageData: Data? {
        didSet {
            updateImage()
        }
    }
    
    lazy private var imageButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(presentPhotoPicker), for: .touchUpInside)
        return button
    }()
    
    lazy private var imageBackgroundView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .systemGray3
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
        
        let placeholderImage = UIImage(systemName: "photo.fill")?
            .withTintColor(.systemGray6, renderingMode: .alwaysOriginal)
        
        let iv = UIImageView()
        view.addSubview(iv)
        iv.image = placeholderImage
        iv.contentMode = .scaleAspectFit
        iv.centerX(inView: view)
        iv.centerY(inView: view)
        iv.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        iv.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8).isActive = true
        
        return view
    }()
    
    private var addPhotoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Photo", for: .normal)
        button.setTitleColor(RFColor.red, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(presentPhotoPicker), for: .touchUpInside)
        return button
    }()

    private var nameTextField: UITextField = {
        let tf = UITextField()
        tf.textContentType = .name
        tf.placeholder = "Add a trip name"
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
    
    private lazy var tripInfoStackView: UIStackView = {
        
        let sectionTitles = ["Trip Name", "Start Date", "End Date"]
        let textFields = [nameTextField, startDateTextField, endDateTextField]
        
        var verticalStackSubViews = [UIView]()
        verticalStackSubViews.append(separatorView())
        
        for i in sectionTitles.indices {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            label.text = sectionTitles[i]
            label.setDimensions(width: 78)
            
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
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    private var nameMatchesTripName: Bool = true
    private var startDateMatchesTripStartDate: Bool = true
    private var endDateMatchesTripEndDate: Bool = true
    private var imageMatchesTripImage: Bool = true
    
    private var shouldEnableRightBarButton: Bool {
        if trip == nil {
            return imageData != nil ||
                   !(nameTextField.text?.isEmpty ?? true) ||
                   !(startDateTextField.text?.isEmpty ?? true) ||
                   !(endDateTextField.text?.isEmpty ?? true)
        } else {
            return !nameMatchesTripName ||
                   !startDateMatchesTripStartDate ||
                   !endDateMatchesTripEndDate ||
                   !imageMatchesTripImage
        }
    }
    
    private var photoButtonTitle: String {
        imageData == nil ? "Add Photo" : "Change Photo"
    }
    
    private var navBarTitle: String {
        trip == nil ? "New Trip" : "Edit Trip"
    }
    
    private var rightBarButtonTitle: String {
        trip == nil ? "Add" : "Save"
    }
    
    
    // MARK: - Lifecycle
    
    init(tripsController: TripsController) {
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
        title = navBarTitle
        navigationController?.navigationBar.tintColor = RFColor.red
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: rightBarButtonTitle,
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(rightBarButtonTapped))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        addPhotoButton.setTitle(photoButtonTitle, for: .normal)
        
        view.addSubview(imageBackgroundView)
        imageBackgroundView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor)
        
        imageBackgroundView.addSubview(imageButton)
        imageButton.anchor(top: imageBackgroundView.topAnchor,
                           left: imageBackgroundView.leftAnchor,
                           bottom: imageBackgroundView.bottomAnchor,
                           right: imageBackgroundView.rightAnchor)
        
        view.addSubview(addPhotoButton)
        addPhotoButton.anchor(top: imageBackgroundView.bottomAnchor,
                              left: view.leftAnchor,
                              right: view.rightAnchor)
        
        view.addSubview(tripInfoStackView)
        tripInfoStackView.anchor(top: addPhotoButton.bottomAnchor,
                                 left: view.leftAnchor,
                                 right: view.rightAnchor,
                                 paddingTop: 16)
    }
    
    private func updateViews() {
        guard let trip = trip else { return }
        
        title = navBarTitle
        navigationItem.rightBarButtonItem?.title = rightBarButtonTitle
        
        nameTextField.text = trip.name
        imageData = trip.image
        
        if let startDate = trip.startDate {
            startDateTextField.text = dateFormatter.string(from: startDate)
            startDatePicker.date = startDate
            endDatePicker.date = startDate
        }
        
        if let endDate = trip.endDate {
            endDateTextField.text = dateFormatter.string(from: endDate)
            endDatePicker.date = endDate
            
            if trip.startDate == nil {
                startDatePicker.date = endDate
            }
        }
    }
    
    private func updateImage() {
        if let data = imageData {
            imageButton.setImage(UIImage(data: data), for: .normal)
        }
        
        addPhotoButton.setTitle(photoButtonTitle, for: .normal)
        
        if let trip = trip {
            imageMatchesTripImage = imageData == trip.image
        }
        navigationItem.rightBarButtonItem?.isEnabled = shouldEnableRightBarButton
    }

    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func presentPhotoPicker() {
        let accessLevel = PHAccessLevel.readWrite
        PHPhotoLibrary.requestAuthorization(for: accessLevel) { (status) in
            if status == .authorized {
                DispatchQueue.main.async {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc private func rightBarButtonTapped() {
        if let trip = trip {
            // Update trip
            trip.name = nameTextField.text ?? ""
            trip.image = imageData
            trip.startDate = dateFormatter.date(from: startDateTextField.text ?? "")
            trip.endDate = dateFormatter.date(from: endDateTextField.text ?? "")
            
            tripsController.updateTrip(trip)
            delegate?.didUpdateTrip(trip)
            
        } else {
            // Create new trip
            let trip = tripsController.addTrip(name: nameTextField.text ?? "New Trip",
                                               image: imageData,
                                               startDate: dateFormatter.date(from: startDateTextField.text ?? ""),
                                               endDate: dateFormatter.date(from: endDateTextField.text ?? ""))
            delegate?.didAddNewTrip(trip)
        }
        
        dismiss(animated: true, completion: nil)
    }

    @objc func tapStartDateDone() {
        if let datePicker = self.startDateTextField.inputView as? UIDatePicker {
            self.startDateTextField.text = dateFormatter.string(from: datePicker.date)
            
            if endDateTextField.text == nil || endDateTextField.text == "" {
                endDatePicker.date = datePicker.date
            }
            
            if let trip = trip {
                startDateMatchesTripStartDate = datePicker.date == trip.startDate
            }
            
            navigationItem.rightBarButtonItem?.isEnabled = shouldEnableRightBarButton
        }
        self.startDateTextField.resignFirstResponder()
    }

    @objc func tapEndDateDone() {
        if let datePicker = self.endDateTextField.inputView as? UIDatePicker {
            self.endDateTextField.text = dateFormatter.string(from: datePicker.date)
            
            if startDateTextField.text == nil || startDateTextField.text == "" {
                startDatePicker.date = datePicker.date
            }
            
            if let trip = trip {
                endDateMatchesTripEndDate = datePicker.date == trip.endDate
            }
            
            navigationItem.rightBarButtonItem?.isEnabled = shouldEnableRightBarButton
        }
        self.endDateTextField.resignFirstResponder()
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        self.imageData = image.pngData()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Selectors
    
    @objc private func textFieldValueChanged() {
        if let trip = trip {
            nameMatchesTripName = nameTextField.text == trip.name
        }
        navigationItem.rightBarButtonItem?.isEnabled = shouldEnableRightBarButton
    }
}
