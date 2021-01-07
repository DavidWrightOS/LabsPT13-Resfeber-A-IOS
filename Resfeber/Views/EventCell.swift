//
//  EventCell.swift
//  Resfeber
//
//  Created by David Wright on 12/14/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import CoreLocation

class EventCell: UICollectionViewCell {
    
    static let reuseIdentifier = "event-cell-reuse-identifier"
    
    enum DateConfiguration {
        case noDates
        case startDate(Date)
        case endDate(Date)
        case startAndEndDate(Date, Date)
    }
    
    // MARK: - Properties
    
    var event: Event? {
        didSet {
            updateViews()
        }
    }

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let imageBGView: UIView = {
        let view = UIView()
        view.setDimensions(height: 32, width: 32)
        view.layer.cornerRadius = 8
        return view
    }()

    private let infoView: UIView = {
        let view = UIView()
        return view
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private let dateLabelTop: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    private let dateLabelBottom: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1).italic
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    private var dateConfiguration: DateConfiguration {
        if let startDate = event?.startDate, let endDate = event?.endDate {
            return .startAndEndDate(startDate, endDate)
            
        } else if let date = event?.startDate {
            return .startDate(date)
            
        } else if let date = event?.endDate {
            return .endDate(date)
        }
        
        return .noDates
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers

private extension EventCell {
    func configureCell() {
        let selectedBGView = UIView(frame: bounds)
        selectedBGView.backgroundColor = RFColor.groupedBackground
        selectedBGView.layer.cornerRadius = 10
        selectedBGView.layer.borderWidth = 1.0
        selectedBGView.layer.borderColor = RFColor.red.cgColor
        selectedBackgroundView = selectedBGView
        
        backgroundColor = RFColor.groupedBackground
        layer.cornerRadius = 10
        clipsToBounds = true
        
        // Configure Date Labels
        let dateStackView = UIStackView(arrangedSubviews: [dateLabelTop, dateLabelBottom])
        dateStackView.axis = .vertical
        dateStackView.alignment = .trailing
        addSubview(dateStackView)
        dateStackView.anchor(top: topAnchor, right: rightAnchor, paddingTop: 8, paddingRight: 8)
        
        // Configure Category Image
        addSubview(imageBGView)
        imageBGView.centerY(inView: self)
        imageBGView.anchor(left: leftAnchor, paddingLeft: 8)
        imageBGView.addSubview(imageView)
        imageView.anchor(top: imageBGView.topAnchor,
                         left: imageBGView.leftAnchor,
                         bottom: imageBGView.bottomAnchor,
                         right: imageBGView.rightAnchor,
                         paddingTop: 4,
                         paddingLeft: 4,
                         paddingBottom: 4,
                         paddingRight: 4)
        
        // Configure Info View
        addSubview(nameLabel)
        nameLabel.anchor(top: topAnchor,
                         left: imageBGView.rightAnchor,
                         right: dateStackView.leftAnchor,
                         paddingTop: 8,
                         paddingLeft: 8,
                         paddingRight: 4)
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        dateStackView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        dateStackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        infoView.addSubview(addressLabel)
        addressLabel.anchor(top: infoView.topAnchor, left: infoView.leftAnchor, right: infoView.rightAnchor)
        
        infoView.addSubview(categoryLabel)
        categoryLabel.anchor(top: addressLabel.bottomAnchor, left: infoView.leftAnchor, right: infoView.rightAnchor, paddingTop: 2)
        categoryLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        addSubview(infoView)
        infoView.anchor(top: nameLabel.bottomAnchor,
                        left: imageBGView.rightAnchor,
                        bottom: bottomAnchor,
                        right: dateStackView.leftAnchor,
                        paddingTop: 2,
                        paddingLeft: 8,
                        paddingBottom: 8,
                        paddingRight: 4)
        
        layoutSubviews()
    }
    
    func updateViews() {
        guard let event = event else { return }
        imageView.image = event.category.annotationGlyph?.withTintColor(.white, renderingMode: .alwaysOriginal)
        imageBGView.backgroundColor = event.category.annotationMarkerTintColor
        
        nameLabel.text = event.name
        categoryLabel.text = event.category.displayName
        addressLabel.text = event.address
        
        updateDateLabels()
    }
    
    private func updateDateLabels() {
        switch dateConfiguration {
        case .noDates:
            dateLabelTop.text = nil
            dateLabelBottom.text = nil
        case .startDate(let date):
            dateLabelTop.text = dateFormatter.string(from: date)
            dateLabelBottom.text = nil
        case .endDate(let date):
            dateLabelTop.text = "Ends"
            dateLabelBottom.text = dateFormatter.string(from: date)
        case .startAndEndDate(let startDate, let endDate):
            dateLabelTop.text = dateFormatter.string(from: startDate)
            dateLabelBottom.text = dateFormatter.string(from: endDate)
        }
    }
}
