//
//  RFInputRow.swift
//  Resfeber
//
//  Created by David Wright on 12/24/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class RFInputRow: UIView {
    
    var rowHeight: CGFloat = 40
    var titleLabelWidth: CGFloat
    
    // MARK: - Initializers
    
    init(rowTitle: String?, titleLabelWidth: CGFloat, inputView: UIView, height: CGFloat? = nil, borderStyle: BorderStyle) {
        self.titleLabelWidth = titleLabelWidth
        
        super.init(frame: .zero)
                
        if let height = height {
            self.rowHeight = height
        }
        
        setupRow(rowTitle: rowTitle, inputView: inputView, borderStyle: borderStyle)
    }
    
    /// This initializer should be used when the input view is a UITextView.
    /// Handles additional setup required to align the text view properly, and provides placeholder functionality
    init(rowTitle: String?, titleLabelWidth: CGFloat, inputTextView: UITextView, placeholderLabel: UILabel, height: CGFloat? = nil, borderStyle: BorderStyle) {
        self.titleLabelWidth = titleLabelWidth
        
        super.init(frame: .zero)
        
        if let height = height {
            self.rowHeight = height
        }
        
        setupRow(rowTitle: rowTitle, inputTextView: inputTextView, placeholderLabel: placeholderLabel, borderStyle: borderStyle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func setupRow(rowTitle: String?, inputView: UIView, borderStyle: UIView.BorderStyle) {
        backgroundColor = RFColor.groupedBackground
        
        setDimensions(height: rowHeight)
        addBorder(borderStyle)
        
        let titleLabel = UILabel()
        addSubview(titleLabel)
        titleLabel.setDimensions(width: titleLabelWidth)
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.text = rowTitle
        titleLabel.anchor(left: leftAnchor, paddingLeft: 20)
        titleLabel.centerYAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        
        addSubview(inputView)
        inputView.anchor(left: titleLabel.rightAnchor, right: rightAnchor, paddingLeft: 4, paddingRight: 20)
        inputView.firstBaselineAnchor.constraint(equalTo: titleLabel.firstBaselineAnchor).isActive = true
    }
    
    private func setupRow(rowTitle: String?, inputTextView: UITextView, placeholderLabel: UILabel, borderStyle: UIView.BorderStyle) {
        
        setupRow(rowTitle: rowTitle, inputView: placeholderLabel, borderStyle: borderStyle)
        
        addSubview(inputTextView)
        inputTextView.backgroundColor = .clear
        inputTextView.textContainer.lineFragmentPadding = 0
        inputTextView.textContainerInset.top = 0
        inputTextView.textContainerInset.left = 0
        inputTextView.centerY(inView: self)
        inputTextView.anchor(top: placeholderLabel.topAnchor,
                             left: placeholderLabel.leftAnchor,
                             right: placeholderLabel.rightAnchor,
                             paddingTop: -1)
    }
}

extension RFInputRow {
    static func spacer(height: CGFloat = 24, borderStyle: UIView.BorderStyle = .none) -> UIView {
        let view = UIView()
        view.setDimensions(height: height)
        view.addBorder(borderStyle)
        return view
    }
}
