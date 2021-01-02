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
    
    private let categoryIndicatorView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = true
        iv.heightAnchor.constraint(equalTo: iv.widthAnchor).isActive = true
        iv.image = UIImage(systemName: "circle.fill")?.withRenderingMode(.alwaysOriginal)
        return iv
    }()

    private let infoView: UIView = {
        let view = UIView()
        return view
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
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
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
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
        selectedBGView.backgroundColor = .systemGray5
        selectedBGView.layer.cornerRadius = 10
        selectedBGView.layer.borderWidth = 1.0
        selectedBGView.layer.borderColor = RFColor.red.cgColor
        selectedBackgroundView = selectedBGView
        
        backgroundColor = .systemGray5
        layer.cornerRadius = 10
        clipsToBounds = true
        
        // Configure Date Label
        addSubview(dateLabel)
        dateLabel.anchor(top: topAnchor, right: rightAnchor, paddingTop: 8, paddingRight: 8)
        
        // Configure Category Image
        addSubview(imageBGView)
        imageBGView.anchor(bottom: bottomAnchor, right: rightAnchor, paddingBottom: 8, paddingRight: 8)
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
        infoView.addSubview(nameLabel)
        nameLabel.anchor(top: infoView.topAnchor, left: infoView.leftAnchor, right: infoView.rightAnchor)
        
        infoView.addSubview(addressLabel)
        addressLabel.anchor(top: nameLabel.bottomAnchor, left: infoView.leftAnchor, right: infoView.rightAnchor, paddingTop: 2)
        
        infoView.addSubview(categoryLabel)
        categoryLabel.anchor(top: addressLabel.bottomAnchor, right: infoView.rightAnchor, paddingTop: 2)
        
        infoView.addSubview(categoryIndicatorView)
        categoryIndicatorView.centerY(inView: categoryLabel)
        categoryIndicatorView.heightAnchor.constraint(equalTo: categoryLabel.heightAnchor, multiplier: 0.65).isActive = true
        categoryIndicatorView.anchor(left: infoView.leftAnchor, right: categoryLabel.leftAnchor, paddingRight: 4)
        categoryIndicatorView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        categoryLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        addSubview(infoView)
        infoView.anchor(top: topAnchor,
                        left: leftAnchor,
                        bottom: bottomAnchor,
                        right: imageView.leftAnchor,
                        paddingTop: 8,
                        paddingLeft: 8,
                        paddingBottom: 8,
                        paddingRight: 4)
        
        layoutSubviews()
    }
    
    func updateViews() {
        guard let event = event else { return }
        imageView.image = event.category.annotationGlyph?.withTintColor(.white, renderingMode: .alwaysOriginal)
        imageBGView.backgroundColor = event.category.annotationMarkerTintColor
        
        let image = UIImage(systemName: "circle.fill")
        let tintColor = event.category.annotationMarkerTintColor
        categoryIndicatorView.image = image?.withTintColor(tintColor, renderingMode: .alwaysOriginal)
        
        nameLabel.text = event.name
        categoryLabel.text = event.category.displayName
        addressLabel.text = event.address
        dateLabel.text = dateString
    }
    
    private var dateString: String? {
        guard let event = event else { return nil }
        
        if let startDate = event.startDate {
            if let endDate = event.endDate, startDate != endDate {
                return "\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))"
            } else {
                return dateFormatter.string(from: startDate)
            }
        }
        
        if let endDate = event.endDate {
            return dateFormatter.string(from: endDate)
        }
        
        return nil
    }
}
