//
//  EventAnnotationDetailView.swift
//  Resfeber
//
//  Created by David Wright on 12/17/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class EventAnnotationDetailView: UIView {
    
    // MARK: - Properties
    
    var event: Event? {
        didSet {
            updateSubviews()
        }
    }
    
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
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureViews() {
        let detailStackView = UIStackView(arrangedSubviews: [addressLabel, categoryLabel])
        detailStackView.axis = .vertical
        detailStackView.spacing = 0
        addSubview(detailStackView)
        detailStackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: -12)
    }
    
    private func updateSubviews() {
        guard let event = event else { return }
        
        if let address = event.address {
            self.addressLabel.text = address
        }
        
        if let category = event.category {
            categoryLabel.text = category
        }
    }
}
