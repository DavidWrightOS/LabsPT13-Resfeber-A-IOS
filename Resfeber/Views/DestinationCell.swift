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
    
    var destination: Destination? {
        didSet {
            if let destination = destination {
                imageView.image = destination.image
                imageView.contentMode = .scaleAspectFill
                bookmarkView.isHidden = !destination.isFavorite
            } else {
                imageView.image = UIImage(named: "Logo_Combined")
                imageView.contentMode = .scaleAspectFit
                bookmarkView.isHidden = true
            }
        }
    }
    
    fileprivate let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .systemGray4
        iv.image = UIImage(named: "Logo_Combined")
        return iv
    }()
    
    fileprivate let bookmarkView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(systemName: "bookmark.fill")
        iv.tintColor = UIColor.Resfeber.red
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
        imageView.addSubview(bookmarkView)
        bookmarkView.anchor(top: imageView.topAnchor, right: imageView.rightAnchor, paddingRight: 16)
        bookmarkView.setDimensions(width: 28)
        bookmarkView.isHidden = true
    }
}
