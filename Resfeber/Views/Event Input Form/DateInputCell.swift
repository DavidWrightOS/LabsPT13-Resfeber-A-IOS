//
//  DateInputCell.swift
//  Resfeber
//
//  Created by David Wright on 12/30/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class DateInputCell: AddEventCell {
    
    static let reuseIdentifier = "date-input-cell-reuse-identifier"
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    // MARK: - Properties
    
    var attributeTitle: String? {
        didSet {
            textLabel?.text = attributeTitle
        }
    }
    
    var placeholder: String? {
        didSet {
            updateViews()
        }
    }
    
    var date: Date? {
        didSet {
            guard date != oldValue else { return }
            if let date = date {
                datePicker.date = date
            }
            updateViews()
            delegate?.didUpdateData(forCell: self)
        }
    }
    
    private var datePicker: UIDatePicker!
    private var datePickerToolBar: UIToolbar!
    
    override var inputView: UIView? { datePicker }
    override var inputAccessoryView: UIView? { datePickerToolBar }
    override var canBecomeFirstResponder: Bool { true }
    override var canResignFirstResponder: Bool { true }

    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        textLabel?.font = UIFont.systemFont(ofSize: 16)
        detailTextLabel?.font = UIFont.systemFont(ofSize: 16)
        accessoryType = .disclosureIndicator
        configureDatePickerInputView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func setDatePickerDate(_ date: Date) {
        datePicker.date = date
    }
    
    private func configureDatePickerInputView() {
        let screenWidth = UIScreen.main.bounds.width
        
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.sizeToFit()
        datePicker.tintColor = RFColor.red
        self.datePicker = datePicker
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(datePickerCancelTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(datePickerDoneTapped))
        ]
        toolBar.setItems(items, animated: false)
        toolBar.tintColor = RFColor.red
        self.datePickerToolBar = toolBar
    }
    
    private func updateViews() {
        if let date = date {
            detailTextLabel?.text = DateInputCell.dateFormatter.string(from: date)
            detailTextLabel?.textColor = RFColor.red
        } else {
            detailTextLabel?.text = placeholder
            detailTextLabel?.textColor = UIColor.secondaryLabel
        }
    }
    
    // MARK: - Selectors
    
    @objc private func datePickerDoneTapped() {
        date = datePicker.date
        resignFirstResponder()
    }
    
    @objc private func datePickerCancelTapped() {
        resignFirstResponder()
    }
}
