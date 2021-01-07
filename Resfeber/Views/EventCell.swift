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

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline).bold
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
        formatter.dateFormat = "E, MMM d"
        return formatter
    }()
    
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
        dateStackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        dateStackView.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        // Configure Category Image
        addSubview(imageBGView)
        imageBGView.centerY(inView: self)
        imageBGView.anchor(left: leftAnchor, paddingLeft: 10)
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
        let infoStackView = UIStackView(arrangedSubviews: [nameLabel, addressLabel, categoryLabel])
        infoStackView.axis = .vertical
        infoStackView.alignment = .leading
        infoStackView.spacing = 2
        addSubview(infoStackView)
        infoStackView.anchor(top: topAnchor,
                        left: imageBGView.rightAnchor,
                        right: dateStackView.leftAnchor,
                        paddingTop: 8,
                        paddingLeft: 10,
                        paddingRight: 4)
        infoStackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: 8).isActive = true
        infoStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
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
        if let startDate = event?.startDate, let endDate = event?.endDate, startDate != endDate {
            dateLabelTop.text = dateFormatter.string(from: startDate)
            dateLabelBottom.text = dateFormatter.string(from: endDate)
            
        } else if let date = event?.startDate {
            dateLabelTop.text = dateFormatter.string(from: date)
            dateLabelBottom.text = nil
            
        } else if let date = event?.endDate {
            dateLabelTop.text = dateFormatter.string(from: date)
            dateLabelBottom.text = nil
            
        } else {
            dateLabelTop.text = nil
            dateLabelBottom.text = nil
        }
    }
}
