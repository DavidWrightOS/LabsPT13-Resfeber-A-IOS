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
    
    fileprivate let destinationController: DestinationController
    fileprivate var collectionView: UICollectionView!

    fileprivate let searchBar: UISearchBar = {
        let sb = UISearchBar(frame: .zero)
        sb.placeholder = "Search"
        sb.searchBarStyle = .minimal
        return sb
    }()

    // MARK: - Lifecycle

    init(destinationController: DestinationController) {
        self.destinationController = destinationController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        // Configure Search Bar
        searchBar.delegate = self
        view.addSubview(searchBar)
        searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 12,
                         paddingLeft: 12,
                         paddingRight: 12)
        
        // Configure Collection View
        // Set layout to custom WaterfallLayout subclass of UICollectionViewLayout
        let layout = WaterfallLayout()
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.Resfeber.background
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(DestinationCell.self, forCellWithReuseIdentifier: DestinationCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.anchor(top: searchBar.bottomAnchor,
                              left: view.leftAnchor,
                              bottom: view.bottomAnchor,
                              right: view.rightAnchor,
                              paddingTop: 12,
                              paddingLeft: 20,
                              paddingRight: 20)
        
        // Load Data
        destinationController.readDestinations()
        collectionView.reloadData()
    }

    fileprivate func performQuery(with searchText: String?) {
        let queryText = searchText ?? ""
        print("DEBUG: Perform query with text: \(queryText)..")
    }
}

// MARK: - Collection View Layout

extension ExploreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
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
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        destinationController.searchDestinations.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DestinationCell.reuseIdentifier, for: indexPath) as! DestinationCell

        cell.destination = destinationController.searchDestinations[indexPath.row]

        return cell
    }
}

// MARK: - Waterfall Layout Delegate

extension ExploreViewController: WaterfallLayoutDelegate {
    func collectionView(_: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let destination = destinationController.searchDestinations[indexPath.row]
        guard let height = destination.image?.size.height else { return 300 }

        print("DEBUG: Image height size is: \(height)")
        if height <= 300 {
            return height
        } else {
            return height / 3
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destination = destinationController.searchDestinations[indexPath.row]
        destination.isFavorite.toggle()

        collectionView.reloadData()
        print("DEBUG: Tapped destination: \(destination.name)..")
    }
}

// MARK: - Collection View Delegate

extension ExploreViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DestinationCell,
              let destination = cell.destination else { return nil }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            // Setup Favorite menu item
            
            let addToFavoritesText = destination.isFavorite ? "Remove Favorite" : "Favorite"
            
            let favoriteImage: UIImage?
            if destination.isFavorite {
                favoriteImage = UIImage(systemName: "heart.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
            } else {
                favoriteImage = UIImage(systemName: "heart")
            }
            
            let addToFavorites = UIAction(title: addToFavoritesText, image: favoriteImage) { [weak self] action in
                guard let self = self else { return }
                self.destinationController.toggleFavoriteStatus(for: destination)
            }
            
            // Setup Itinerary menu item
            
            let addToItinerary: UIAction
            if destination.isOnItinerary {
                addToItinerary = UIAction(title: "Added to Itinerary", image: UIImage(systemName: "briefcase"), attributes: .disabled, handler: {_ in})
            } else {
                addToItinerary = UIAction(title: "Add to Itinerary", image: UIImage(systemName: "briefcase")) { [weak self] action in
                    guard let self = self else { return }
                    self.destinationController.toggleItineraryStatus(for: destination)
                }
            }
            
            return UIMenu(title: "", children: [addToFavorites, addToItinerary])
        }
    }
}

// MARK: - Search Bar Delegate

extension ExploreViewController: UISearchBarDelegate {
    func searchBar(_: UISearchBar, textDidChange searchText: String) {
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
