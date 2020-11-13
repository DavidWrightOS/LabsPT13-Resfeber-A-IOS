//
//  FavoritesViewController.swift
//  Resfeber
//
//  Created by Joshua Rutkowski on 11/11/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    // MARK: - Properties

    fileprivate var collectionView: UICollectionView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    // MARK: - Helpers

    fileprivate func configureViews() {
        view.backgroundColor = UIColor.Resfeber.background
        
        // Configure Collection View
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.Resfeber.background
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(DestinationCell.self, forCellWithReuseIdentifier: DestinationCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              left: view.leftAnchor,
                              bottom: view.bottomAnchor,
                              right: view.rightAnchor,
                              paddingTop: 12,
                              paddingLeft: 20,
                              paddingRight: 20)
        
    }
}

// MARK: - Collection View Layout

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        let xInsets: CGFloat = 16
        let cellWidth = width - (xInsets * 2)
        let cellHeight: CGFloat = cellWidth * 0.65
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
}

// MARK: - Collection View Data Source

extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DestinationCell.reuseIdentifier, for: indexPath) as! DestinationCell

        return cell
    }
}
