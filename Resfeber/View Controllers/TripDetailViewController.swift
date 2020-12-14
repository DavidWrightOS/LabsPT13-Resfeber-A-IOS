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
    
    private let searchTableView = UITableView()
    private var searchResults = [MKPlacemark]() {
        didSet {
            for result in searchResults {
                let annotation = MKPointAnnotation()
                annotation.coordinate = result.coordinate
                self.mapView.addAnnotation(annotation)
            }
            let annotations = self.mapView.annotations
            self.mapView.zoomToFit(annotations: annotations)
        }
    }
    
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    
    fileprivate var collectionView: UICollectionView!
    
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
        
        // Configure Collection View
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = RFColor.background
        collectionView.register(EventCell.self, forCellWithReuseIdentifier: EventCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.anchor(top: mapView.bottomAnchor,
                              left: view.leftAnchor,
                              bottom: view.bottomAnchor,
                              right: view.rightAnchor,
                              paddingTop: 12,
                              paddingLeft: 12,
                              paddingRight: 12)
        
        // Load Data
        collectionView.reloadData()
        
        configureTableView()
        loadTripAnnotations()
    }
    
    private func configureTableView() {
        searchTableView.backgroundColor = RFColor.background
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseIdentifier)
        searchTableView.rowHeight = 60
        searchTableView.tableFooterView = UIView()
        
        let height = view.frame.height - view.safeAreaInsets.top
        searchTableView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: height)
        view.addSubview(searchTableView)
    }
    
    func loadTripAnnotations() {
        for event in events {
            let coordinate = CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            self.mapView.addAnnotation(annotation)
        }
        
        let annotations = mapView.annotations
        self.mapView.zoomToFit(annotations: annotations)
    }
    
    fileprivate func performQuery(with searchText: String?) {
        let queryText = searchText ?? ""
        
        searchBy(naturalLanguageQuery: queryText) { results in
            self.searchResults = results
            self.searchTableView.reloadData()
        }
    }
    
    func searchBy(naturalLanguageQuery: String, completion: @escaping([MKPlacemark]) -> Void) {
        var results = [MKPlacemark]()
        
        let request = MKLocalSearch.Request()
        request.region = mapView.region
        request.naturalLanguageQuery = naturalLanguageQuery
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else { return }
            
            response.mapItems.forEach { item in
                results.append(item.placemark)
            }
            
            completion(results)
        }
    }
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

// MARK: - Collection View Layout
extension TripDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.size.width
        let cellHeight: CGFloat = 70
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

// MARK: - Collection View Data Source
extension TripDetailViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        events.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCell.reuseIdentifier, for: indexPath) as! EventCell

        cell.event = events[indexPath.row]

        return cell
    }
}

// MARK: - Search Table View DataSource

extension TripDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.reuseIdentifier, for: indexPath) as! SearchResultCell
        cell.placemark = searchResults[indexPath.row]
        return cell
    }
}

// MARK: - Search Table View Delegate

extension TripDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlacemark = searchResults[indexPath.row]
        
        dismissSearchTableView { _ in
            let annotation = MKPointAnnotation()
            annotation.coordinate = selectedPlacemark.coordinate
            self.mapView.addAnnotation(annotation)
            self.mapView.selectAnnotation(annotation, animated: true)
            
            let annotations = self.mapView.annotations
            self.mapView.zoomToFit(annotations: annotations)
        }
    }
}
