//
//  SideMenuCell.swift
//  Resfeber
//
//  Created by David Wright on 11/17/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {
    
    // MARK: - Properties
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = RFColor.light
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = RFColor.red
        selectionStyle = .none
        
        addSubview(iconImageView)
        iconImageView.setDimensions(height: 24, width: 24)
        iconImageView.centerY(inView: self)
        iconImageView.anchor(left: leftAnchor, paddingLeft: 12)
        
        addSubview(descriptionLabel)
        descriptionLabel.centerY(inView: self)
        descriptionLabel.anchor(left: iconImageView.rightAnchor, paddingLeft: 12)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
