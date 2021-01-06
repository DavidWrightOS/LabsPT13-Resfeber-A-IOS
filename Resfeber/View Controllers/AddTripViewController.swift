//
//  AddTripViewController.swift
//  Resfeber
//
//  Created by Joshua Rutkowski on 12/5/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import PhotosUI

class AddTripViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    private let tripsController: TripsController
    
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
    
    private var photoButtonTitle: String {
        imageData == nil ? "Add Photo" : "Change Photo"
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
        navigationController?.navigationBar.tintColor = RFColor.red
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(addNewTripWasCancelled))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(newTripWasSaved))
        navigationItem.rightBarButtonItem?.isEnabled = false
        title = "New Trip"
        
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
    
    private func updateImage() {
        if let data = imageData {
            imageButton.setImage(UIImage(data: data), for: .normal)
        }
        
        addPhotoButton.setTitle(photoButtonTitle, for: .normal)
    }

    @objc func addNewTripWasCancelled() {
        self.dismiss(animated: true, completion: nil)
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
    //TODO: Add save image from image picker
    // Save dates to CoreData
    @objc func newTripWasSaved() {
        let trip = tripsController.addTrip(name: nameTextField.text ?? "",
                                       image: imageData,
                                       startDate: nil,
                                       endDate: nil)
        print("Trip was created: \(trip)")
        NotificationCenter.default.post(name: .loadData, object: nil)
        self.dismiss(animated: true, completion: nil)
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
        navigationItem.rightBarButtonItem?.isEnabled = !(nameTextField.text?.isEmpty ?? true)
    }
}
