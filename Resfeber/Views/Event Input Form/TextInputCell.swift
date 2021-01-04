//
//  TextInputCell.swift
//  Resfeber
//
//  Created by David Wright on 12/30/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class TextInputCell: EventDetailCell {
    
    static let reuseIdentifier = "text-input-cell-reuse-identifier"
    
    // MARK: - Properties
    
    var placeholder: String? {
        didSet {
            leftTextField.placeholder = placeholder
        }
    }
    
    var inputText: String? {
        didSet {
            if inputText != leftTextField.text {
                leftTextField.text = inputText
            }
            
            guard inputText != oldValue else { return }
            
            delegate?.didUpdateData(forCell: self)
        }
    }
    
    lazy private var leftTextField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.textColor = RFColor.red
        tf.tintColor = RFColor.red
        tf.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        return tf
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(leftTextField)
        leftTextField.centerY(inView: contentView)
        leftTextField.anchor(top: contentView.layoutMarginsGuide.topAnchor,
                             left: contentView.layoutMarginsGuide.leftAnchor,
                             right: contentView.layoutMarginsGuide.rightAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    override func becomeFirstResponder() -> Bool {
        leftTextField.becomeFirstResponder()
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        leftTextField.resignFirstResponder()
        return true
    }
    
    // MARK: - Selectors
    
    @objc private func textFieldValueChanged() {
        inputText = leftTextField.text
    }
}
