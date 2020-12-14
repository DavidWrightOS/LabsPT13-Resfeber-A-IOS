//
//  TripDetailViewController.swift
//  Resfeber
//
//  Created by David Wright on 12/13/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import MapKit

class TripDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private var trip: Trip {
        didSet {
            events = trip.events?.allObjects as? [Event] ?? []
        }
    }
    
    fileprivate let tripService: TripService
    
    private var events: [Event]
    
    fileprivate let searchBar: UISearchBar = {
        let sb = UISearchBar(frame: .zero)
        sb.tintColor = RFColor.red
        sb.placeholder = "Search for a place or address"
        sb.searchBarStyle = .minimal
        return sb
    }()
    
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    
    // MARK: - Lifecycle
    
    init(_ trip: Trip, tripService: TripService) {
        self.trip = trip
        self.events = trip.events?.allObjects as? [Event] ?? []
        self.tripService = tripService
        
        // load mock events
        if events.isEmpty {
            self.events = [
                tripService.addEvent(name: "Apple Park Visitor Center",
                                     eventDescription: nil,
                                     category: "Other",
                                     latitude: 37.3326,
                                     longitude: -122.0055,
                                     startDate: Date(timeIntervalSinceNow: 86400 * 31),
                                     endDate: Date(timeIntervalSinceNow: 86400 * 31 + 7200),
                                     notes: nil,
                                     trip: trip),
                tripService.addEvent(name: "Aloft Cupertino",
                                     eventDescription: nil,
                                     category: "Accomodation",
                                     latitude: 37.3255,
                                     longitude: -122.0329,
                                     startDate: Date(timeIntervalSinceNow: 86400 * 30),
                                     endDate: Date(timeIntervalSinceNow: 86400 * 37),
                                     notes: "No smoking; Pet friendly",
                                     trip: trip),
                tripService.addEvent(name: "Lazy Dog Restaurant & Bar",
                                     eventDescription: nil,
                                     category: "Restaurant",
                                     latitude: 37.1924,
                                     longitude: -122.0031,
                                     startDate: Date(timeIntervalSinceNow: 86400 * 33),
                                     endDate: Date(timeIntervalSinceNow: 86400 * 33 + 7200),
                                     notes: "COVID-19 Restrictions: open for takeout and delivery only",
                                     trip: trip),
            ]
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableLocationServices()
        configureViews()
    }
    
    // MARK: - Helpers
    
    fileprivate func configureViews() {
        navigationItem.title = trip.name
        view.backgroundColor = RFColor.background
        
        // Configure Search Bar
        searchBar.delegate = self
        view.addSubview(searchBar)
        searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingLeft: 8,
                         paddingRight: 8)
        
        // Configure MapView
        mapView.showsUserLocation = true
        mapView.layer.borderWidth = 1
        mapView.layer.borderColor = RFColor.red.cgColor
        view.addSubview(mapView)
        mapView.anchor(top: searchBar.bottomAnchor,
                       left: view.leftAnchor,
                       right: view.rightAnchor,
                       paddingTop: 4,
                       paddingLeft: 12,
                       paddingRight: 12,
                       height: view.frame.width * 0.8)
    }
    
    fileprivate func performQuery(with searchText: String?) {
        let queryText = searchText ?? ""
        print("DEBUG: Perform query with text: \(queryText)..")
    }
}

extension TripDetailViewController: CLLocationManagerDelegate {
    fileprivate func enableLocationServices() {
        locationManager.delegate = self
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        default:
            break
        }
    }
}

// MARK: - Search Bar Delegate
extension TripDetailViewController: UISearchBarDelegate {
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
