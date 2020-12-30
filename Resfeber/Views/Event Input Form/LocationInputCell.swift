//
//  LocationInputCell.swift
//  Resfeber
//
//  Created by David Wright on 12/30/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import MapKit

class LocationInputCell: AddEventCell {
    
    static let reuseIdentifier = "location-input-cell-reuse-identifier"
    
    // MARK: - Properties
    
    var attributeTitle: String?
    
    var placeholder: String? {
        didSet {
            updateViews()
        }
    }
    
    var placemark: MKPlacemark? {
        didSet {
            guard placemark != oldValue else { return }
            updateViews()
            delegate?.didUpdateData(forCell: self)
        }
    }
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        detailTextLabel?.textColor = RFColor.red
        updateViews()
        textLabel?.textColor = UIColor.placeholderText
        textLabel?.text = placeholder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func updateViews() {
        if let placemark = placemark {
            textLabel?.textColor = RFColor.red
            textLabel?.text = placemark.name
            detailTextLabel?.text = placemark.address
        } else {
            textLabel?.textColor = UIColor.placeholderText
            textLabel?.text = placeholder
            detailTextLabel?.text = nil
        }
    }
}
