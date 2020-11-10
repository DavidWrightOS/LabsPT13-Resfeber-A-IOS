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
            updateViews()
        }
    }

    fileprivate let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .systemGray4
        iv.image = UIImage(named: "Logo_Combined")
        return iv
    }()

    fileprivate let infoView: UIView = {
        let view = UIView()
        view.setDimensions(height: 50)
        return view
    }()

    fileprivate let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Destination Name"
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()

    fileprivate let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.clear.cgColor,
                        UIColor.black.withAlphaComponent(0.4).cgColor,
                        UIColor.black.withAlphaComponent(0.5).cgColor]
        layer.locations = [0, 0.5, 1.0]
        layer.shouldRasterize = true
        return layer
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

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DestinationCell {
    func configureCell() {
        layer.cornerRadius = 10
        clipsToBounds = true
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)

        // Configure Info View
        infoView.layer.insertSublayer(gradientLayer, at: 0)
        infoView.addSubview(infoLabel)
        infoLabel.anchor(left: infoView.leftAnchor, bottom: infoView.bottomAnchor,
                         right: infoView.rightAnchor, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        addSubview(infoView)
        infoView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        gradientLayer.frame = infoView.bounds

        // Configure Bookmark
        addSubview(bookmarkView)
        bookmarkView.anchor(top: topAnchor, right: rightAnchor, paddingRight: 16)
        bookmarkView.setDimensions(width: 28)
        bookmarkView.isHidden = true

        layoutSubviews()
    }

    func updateViews() {
        if let destination = destination {
            imageView.image = destination.image
            imageView.contentMode = .scaleAspectFill
            infoLabel.text = destination.name
            bookmarkView.isHidden = !destination.isFavorite
            gradientLayer.frame = infoView.bounds
        } else {
            imageView.image = UIImage(named: "Logo_Combined")
            imageView.contentMode = .scaleAspectFit
            bookmarkView.isHidden = true
        }
    }
}
