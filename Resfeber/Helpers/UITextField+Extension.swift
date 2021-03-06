//
//  UITextField+Extension.swift
//  Resfeber
//
//  Created by Joshua Rutkowski on 12/5/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
extension UITextField {
    
    @discardableResult
    func setInputViewDatePicker(target: Any, selector: Selector) -> UIDatePicker {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.sizeToFit()
        datePicker.tintColor = RFColor.red
        self.inputView = datePicker
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        cancel.tintColor = RFColor.red
        barButton.tintColor = RFColor.red
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
        
        return datePicker
    }
    
    @discardableResult
    func setInputViewCategoryPicker<T: UIPickerViewDataSource & UIPickerViewDelegate>(target: T, selector: Selector) -> UIPickerView {
        // Create a UIPickerView object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        picker.dataSource = target
        picker.delegate = target
        picker.sizeToFit()
        picker.tintColor = RFColor.red
        self.inputView = picker
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        cancel.tintColor = RFColor.red
        barButton.tintColor = RFColor.red
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
        
        return picker
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
}
