//
//  CategoryInputCell.swift
//  Resfeber
//
//  Created by David Wright on 12/30/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class CategoryInputCell: AddEventCell {
    
    static let reuseIdentifier = "category-input-cell-reuse-identifier"
    
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
    
    var category: EventCategory? {
        didSet {
            guard category != oldValue else { return }
            updateViews()
            delegate?.didUpdateData(forCell: self)
        }
    }
    
    private var categoryPicker: UIPickerView!
    private var categoryPickerToolBar: UIToolbar!
    
    override var inputView: UIView? { categoryPicker }
    override var inputAccessoryView: UIView? { categoryPickerToolBar }
    override var canBecomeFirstResponder: Bool { true }
    override var canResignFirstResponder: Bool { true }
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        textLabel?.font = UIFont.systemFont(ofSize: 16)
        detailTextLabel?.font = UIFont.systemFont(ofSize: 16)
        accessoryType = .disclosureIndicator
        configureCategoryPickerInputView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureCategoryPickerInputView() {
        let screenWidth = UIScreen.main.bounds.width
        
        let picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        picker.dataSource = self
        picker.delegate = self
        picker.sizeToFit()
        picker.tintColor = RFColor.red
        self.categoryPicker = picker
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(categoryPickerCancelTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(categoryPickerDoneTapped))
        ]
        toolBar.setItems(items, animated: false)
        toolBar.tintColor = RFColor.red
        self.categoryPickerToolBar = toolBar
    }
    
    private func updateViews() {
        if let category = category, let categoryName = category.displayName {
            detailTextLabel?.text = categoryName
            detailTextLabel?.textColor = RFColor.red
        } else {
            detailTextLabel?.text = placeholder
            detailTextLabel?.textColor = UIColor.secondaryLabel
        }
    }
    
    // MARK: - Selectors
    
    @objc private func categoryPickerDoneTapped() {
        let selectedRow = categoryPicker.selectedRow(inComponent: 0)
        category = EventCategory(rawValue: selectedRow)
        resignFirstResponder()
    }
    
    @objc private func categoryPickerCancelTapped() {
        resignFirstResponder()
    }
}

// MARK: - UIPickerView Data Source

extension CategoryInputCell: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        EventCategory.displayNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let categoryName = EventCategory.displayNames[row] ?? "- Select Category -"
        let textColor = EventCategory.displayNames[row] == nil ? UIColor.placeholderText : UIColor.label
        let attributes = [NSAttributedString.Key.foregroundColor : textColor]
        return NSAttributedString(string: categoryName, attributes: attributes)
    }
}
