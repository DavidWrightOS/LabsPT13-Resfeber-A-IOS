//
//  ExploreViewController.swift
//  Resfeber
//
//  Created by David Wright on 11/8/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController {
    
    // MARK: - Properties
    
    fileprivate var collectionView: UICollectionView!
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        label.text = "Explore"
        return label
    }()
    
    fileprivate let profileButton: UIButton = {
        let button = UIButton(type: .system)
        let buttonDiameter: CGFloat = 32
        button.setDimensions(height: buttonDiameter, width: buttonDiameter)
        button.layer.cornerRadius = buttonDiameter / 2
        button.layer.masksToBounds = true
        button.contentMode = .scaleAspectFill
        button.backgroundColor = .systemGray3
        button.addTarget(self, action: #selector(profileImageTapped), for: .touchUpInside)
        
        let image = UIImage(systemName: "person.fill")!.withTintColor(.systemGray6, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    fileprivate let searchBar: UISearchBar = {
        let sb = UISearchBar(frame: .zero)
        sb.placeholder = "Search"
        sb.searchBarStyle = .minimal
        return sb
    }()
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        
        if let layout = collectionView?.collectionViewLayout as? WaterfallLayout {
          layout.delegate = self
        }
    }
    
    // MARK: - Selectors
    
    @objc fileprivate func profileImageTapped() {
        print("DEBUG: profileImageTapped..")
    }
    
    // MARK: - Helpers
    
    fileprivate func configureViews() {
        view.backgroundColor = UIColor.Resfeber.background
        navigationController?.navigationBar.isHidden = true
        
        // Configure Title Label
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                          right: view.rightAnchor, paddingTop: 4, paddingLeft: 20, paddingRight: 20)
        
        // Configure Profile Button
        view.addSubview(profileButton)
        profileButton.anchor(right: view.rightAnchor, paddingRight: 20)
        profileButton.centerY(inView: titleLabel)
        
        // Configure Search Bar
        searchBar.delegate = self
        view.addSubview(searchBar)
        searchBar.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                         paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        
        // Configure Collection View
//        let layout = UICollectionViewFlowLayout()
        // Set layout to custom WaterfallLayout subclass of UICollectionViewLayout
        let layout = WaterfallLayout()
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.Resfeber.background
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(DestinationCell.self, forCellWithReuseIdentifier: DestinationCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.anchor(top: searchBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor,
                              right: view.rightAnchor, paddingTop: 12, paddingLeft: 20, paddingRight: 20)
        
        // Load Data
        DestinationController.readDestinations()
        collectionView.reloadData()
    }
    
    fileprivate func performQuery(with searchText: String?) {
        let queryText = searchText ?? ""
        print("DEBUG: Perform query with text: \(queryText)..")
    }
}

// MARK: - Collection View Layout

extension ExploreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = 2
        let width = collectionView.frame.size.width
        let xInsets: CGFloat = 0
        let cellSpacing: CGFloat = 8
        let cellWidth = (width / numberOfColumns) - (xInsets + cellSpacing)
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

// MARK: - Collection View Data Source

extension ExploreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Data.destinations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DestinationCell.reuseIdentifier, for: indexPath) as! DestinationCell
        
        cell.destination = Data.destinations[indexPath.row]
        
        return cell
    }
}

// MARK: - Collection View Delegate

extension ExploreViewController: WaterfallLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let destination = Data.destinations[indexPath.row]
        guard let height = destination.image?.size.height else { return 300 }
        
        print("DEBUG: Image height size is: \(height)")
        if height <= 300 {
            return height
        } else {
            return height / 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destination = Data.destinations[indexPath.row]
        destination.isFavorite.toggle()
        
        collectionView.reloadData()
        print("DEBUG: Tapped destination: \(destination.name)..")
    }
}

// MARK: - Search Bar Delegate

extension ExploreViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("DEBUG: Search bar text changed: \(searchText)..")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        performQuery(with: searchBar.text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
}


