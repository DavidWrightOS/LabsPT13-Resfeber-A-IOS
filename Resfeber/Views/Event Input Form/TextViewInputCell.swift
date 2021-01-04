//
//  TextViewInputCell.swift
//  Resfeber
//
//  Created by David Wright on 12/30/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class TextViewInputCell: EventDetailCell {
    
    static let reuseIdentifier = "multi-line-text-input-cell-reuse-identifier"
    
    // MARK: - Properties
    
    var placeholder: String? {
        didSet {
            textViewPlaceholderLabel.text = placeholder
        }
    }
    
    var inputText: String? {
        didSet {
            if inputText != leftTextView.text {
                leftTextView.text = inputText
                textViewPlaceholderLabel.isHidden = !leftTextView.text.isEmpty
            }
            
            guard inputText != oldValue else { return }
            
            delegate?.didUpdateData(forCell: self)
        }
    }
    
    lazy private var leftTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = RFColor.red
        tv.tintColor = RFColor.red
        tv.backgroundColor = .clear
        tv.textContainer.lineFragmentPadding = 0
        tv.textContainerInset.top = 0
        tv.textContainerInset.left = 0
        tv.delegate = self
        tv.setDimensions(height: 150)
        return tv
    }()
    
    lazy private var textViewPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.font = leftTextView.font
        label.textColor = UIColor.placeholderText
        return label
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(textViewPlaceholderLabel)
        textViewPlaceholderLabel.anchor(top: contentView.layoutMarginsGuide.topAnchor,
                                        left: contentView.layoutMarginsGuide.leftAnchor,
                                        right: contentView.layoutMarginsGuide.rightAnchor)
        
        contentView.addSubview(leftTextView)
        leftTextView.centerY(inView: self)
        leftTextView.anchor(top: contentView.layoutMarginsGuide.topAnchor,
                            left: contentView.layoutMarginsGuide.leftAnchor,
                            bottom: contentView.layoutMarginsGuide.bottomAnchor,
                            right: contentView.layoutMarginsGuide.rightAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    override func becomeFirstResponder() -> Bool {
        leftTextView.becomeFirstResponder()
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        leftTextView.resignFirstResponder()
        return true
    }
}

// MARK: - UITextViewDelegate

extension TextViewInputCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textViewPlaceholderLabel.isHidden = !textView.text.isEmpty
        inputText = leftTextView.text
    }
}
