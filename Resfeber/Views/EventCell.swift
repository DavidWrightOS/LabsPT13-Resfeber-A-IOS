//
//  EventCell.swift
//  Resfeber
//
//  Created by David Wright on 12/14/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import CoreLocation

protocol EventCellDelegate: class {
    func categoryIconTapped(for cell: EventCell)
}

class EventCell: UICollectionViewCell {
    
    static let reuseIdentifier = "event-cell-reuse-identifier"
    
    // MARK: - Properties
    
    weak var delegate: EventCellDelegate?
    
    var event: Event? {
        didSet {
            updateViews()
        }
    }
    
    var categoryIconIsSelected = false {
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
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Configure cell shadow
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 0.05
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        
        configureCell()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
    }
    
    override func prepareForReuse() {
        categoryIconIsSelected = false
    }
    
    // MARK: - Selectors
    
    @objc private func categoryIconTapped() {
        delegate?.categoryIconTapped(for: self)
    }
}

// MARK: - Helpers

private extension EventCell {
    func configureCell() {
        
        // Configure Date Labels
        let dateStackView = UIStackView(arrangedSubviews: [dateLabelTop, dateLabelBottom])
        dateStackView.axis = .vertical
        dateStackView.alignment = .trailing
        contentView.addSubview(dateStackView)
        dateStackView.anchor(top: contentView.topAnchor, right: contentView.rightAnchor, paddingTop: 8, paddingRight: 8)
        dateStackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        dateStackView.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        // Configure Category Image
        contentView.addSubview(imageBGView)
        imageBGView.centerY(inView: contentView)
        imageBGView.anchor(left: contentView.leftAnchor, paddingLeft: 10)
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
        contentView.addSubview(infoStackView)
        infoStackView.anchor(top: contentView.topAnchor,
                        left: imageBGView.rightAnchor,
                        right: dateStackView.leftAnchor,
                        paddingTop: 8,
                        paddingLeft: 10,
                        paddingRight: 4)
        
        infoStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: 8).isActive = true
        infoStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        // Add button to make the category icon tappable
        let categoryIconButton = UIButton()
        contentView.addSubview(categoryIconButton)
        categoryIconButton.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: infoStackView.leftAnchor)
        categoryIconButton.addTarget(self, action: #selector(categoryIconTapped), for: .touchUpInside)
    }
    
    func updateViews() {
        guard let event = event else { return }
        
        if let eventName = event.name, !eventName.isEmpty {
            nameLabel.text = eventName
        } else {
            nameLabel.text = event.locationName
        }
        
        addressLabel.text = event.address
        categoryLabel.text = event.category.displayName
        updateDateLabels()
        
        let categoryColor = event.category.annotationMarkerTintColor
        
        if categoryIconIsSelected {
            imageBGView.backgroundColor = categoryColor
            imageView.image = event.category.annotationGlyph?.withTintColor(.white, renderingMode: .alwaysOriginal)
            contentView.backgroundColor = categoryColor.withAlphaComponent(0.15)
        } else {
            imageBGView.backgroundColor = nil
            imageView.image = event.category.annotationGlyph?.withTintColor(categoryColor, renderingMode: .alwaysOriginal)
            contentView.backgroundColor = RFColor.groupedBackground
        }
        
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
