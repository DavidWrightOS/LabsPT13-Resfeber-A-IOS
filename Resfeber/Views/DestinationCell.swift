//
//  DestinationCell.swift
//  Resfeber
//
//  Created by David Wright on 11/9/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class DestinationCell: UICollectionViewCell {
    
    static let reuseIdentifier = "destination-cell-reuse-identifier"
    
    var image: UIImage? {
        didSet {
            imageView.image = image ?? UIImage(named: "Logo_Combined")
        }
    }
    
    fileprivate let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .systemGray4
        iv.image = UIImage(named: "Logo_Combined")
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DestinationCell {
    fileprivate func configureCell() {
        layer.cornerRadius = 10
        clipsToBounds = true
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
}
