//
//  TripsViewController.swift
//  Resfeber
//
//  Created by David Wright on 11/8/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class TripsViewController: UIViewController {
    
    // MARK: - Properties
    
    private var collectionView: UICollectionView!
    
    private let tripsController = TripsController()

    var profile: Profile? {
        didSet {
            if profile?.id != oldValue?.id {
                tripsController.loadTrips()
            }
            updateViews()
        }
    }
    
    lazy var profileButton: UIBarButtonItem = {
        UIBarButtonItem(customView: profileButtonCustomView)
    }()
    
    let profileButtonCustomView: UIButton = {
        let buttonDiameter: CGFloat = 32
        let button = UIButton(type: .custom)
        button.setDimensions(height: buttonDiameter, width: buttonDiameter)
        button.layer.cornerRadius = buttonDiameter / 2
        button.layer.masksToBounds = true
        button.backgroundColor = .white
        button.tintColor = .systemGray
        button.addTarget(self, action: #selector(profileImageTapped), for: .touchUpInside)
        return button
    }()
    
    private let placeholderProfileImage: UIImage? = {
        let config = UIImage.SymbolConfiguration(pointSize: 25.5)
        let image = UIImage(systemName: "person.crop.circle.fill")?
            .withConfiguration(config)
        return image
    }()

    weak var sideMenuDelegate: SideMenuDelegate?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        tripsController.delegate = self
    }

    // MARK: - Selectors
    
    @objc private func profileImageTapped() {
        sideMenuDelegate?.toggleSideMenu(withMenuOption: nil)
    }

    @objc func addButtonTapped(sender: UIButton) {
        let addTripVC = AddTripViewController(tripsController: tripsController)
        addTripVC.delegate = self
        let nav = UINavigationController(rootViewController: addTripVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }

    // MARK: - Helpers

    private func configureViews() {
        view.backgroundColor = RFColor.background

        // Configure Navigation Bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = RFColor.red
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.text = "My Trips"
        navigationItem.titleView = titleLabel
        navigationItem.leftBarButtonItem = profileButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))

        // Configure Collection View
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = RFColor.background
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(TripCell.self, forCellWithReuseIdentifier: TripCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              left: view.leftAnchor,
                              bottom: view.bottomAnchor,
                              right: view.rightAnchor,
                              paddingTop: 20,
                              paddingLeft: 20,
                              paddingRight: 20)
        
        updateViews()
    }
    
    func updateViews() {
        guard collectionView != nil else { return }
        
        if let image = profile?.avatarImage {
            profileButtonCustomView.imageView?.contentMode = .scaleAspectFill
            profileButtonCustomView.setImage(image, for: .normal)
        } else {
            profileButtonCustomView.imageView?.contentMode = .center
            profileButtonCustomView.setImage(placeholderProfileImage, for: .normal)
        }
        
        collectionView.reloadData()
    }
}

// MARK: - Collection View Layout
extension TripsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = 1
        let width = collectionView.frame.size.width
        let xInsets: CGFloat = 16
        let cellSpacing: CGFloat = 0
        let cellWidth = (width / numberOfColumns) - (xInsets + cellSpacing)
        let cellHeight: CGFloat = cellWidth * 0.64
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
}

// MARK: - Collection View Data Source
extension TripsViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        tripsController.trips.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TripCell.reuseIdentifier, for: indexPath) as! TripCell

        cell.trip = tripsController.trips[indexPath.row]

        return cell
    }
}

// MARK: - Collection View Delegate
extension TripsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TripCell,
              let trip = cell.trip else { return }
        
        let detailVC = TripDetailViewController(trip, tripsController: tripsController)
        detailVC.tripDetailVCDelegate = self
        show(detailVC, sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TripCell,
              let trip = cell.trip else { return nil }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            // Setup Edit Trip menu item
            let editTrip = UIAction(title: "Edit Trip", image: UIImage(systemName: "square.and.pencil")) { [weak self] action in
                guard let self = self else { return }
                self.showEditTripViewController(with: trip)
            }
            
            // Setup Delete Trip menu item
            let deleteTrip = UIAction(title: "Delete Trip", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] action in
                guard let self = self else { return }
                self.tripsController.deleteTrip(trip)
            }
            
            return UIMenu(title: "", children: [editTrip, deleteTrip])
        }
    }
    
    private func showEditTripViewController(with trip: Trip) {
        let addTripVC = AddTripViewController(tripsController: tripsController)
        addTripVC.delegate = self
        addTripVC.trip = trip
        let nav = UINavigationController(rootViewController: addTripVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}

// MARK: - TripDetailViewController Delegate
extension TripsViewController: TripDetailViewControllerDelegate {
    func didUpdateTrip(_ trip: Trip) {
        collectionView.reloadData()
    }
    
    func didDeleteTrip(_ trip: Trip) {
        collectionView.reloadData()
    }
}

// MARK: - AddTripViewController Delegate
extension TripsViewController: AddTripViewControllerDelegate {
    func didAddNewTrip(_ trip: Trip) {
        collectionView.reloadData()
    }
}

// MARK: - TripsController Delegate
extension TripsViewController: TripsControllerDelegate {
    func didUpdateTrips() {
        collectionView.reloadData()
        print("collectionView.reloadData()")
    }
}
