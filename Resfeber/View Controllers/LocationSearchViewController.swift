//
//  LocationSearchViewController.swift
//  Resfeber
//
//  Created by David Wright on 12/22/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import MapKit

protocol LocationSearchViewControllerDelegate: class {
    func didSelectLocation(with placemark: MKPlacemark)
}

class LocationSearchViewController: UIViewController {
    
    // MARK: - Properties
    
    private let searchBar: UISearchBar = {
        let sb = UISearchBar(frame: .zero)
        sb.tintColor = RFColor.red
        sb.placeholder = "Enter location"
        sb.searchBarStyle = .minimal
        return sb
    }()
    
    private let searchTableView = UITableView()
    private var searchResults = [MKMapItem]()
    
    var searchRegion: MKCoordinateRegion?
    
    weak var delegate: LocationSearchViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    // MARK: - Helpers
    
    private func configureViews() {
        view.backgroundColor = RFColor.background
        navigationItem.title = "Location"
        
        // Configure Search Bar
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        view.addSubview(searchBar)
        searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingLeft: 8,
                         paddingRight: 8)
        
        // Configure Table View
        searchTableView.backgroundColor = RFColor.background
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseIdentifier)
        searchTableView.rowHeight = 60
        searchTableView.tableFooterView = UIView()
        view.addSubview(searchTableView)
        searchTableView.anchor(top: searchBar.bottomAnchor,
                              left: view.leftAnchor,
                              bottom: view.bottomAnchor,
                              right: view.rightAnchor,
                              paddingTop: 12)
    }
    
    private func performQuery(with searchText: String?) {
        let queryText = searchText ?? ""
        
        searchBy(naturalLanguageQuery: queryText) { results in
            self.searchResults = results
            self.searchTableView.reloadData()
        }
    }
    
    func searchBy(naturalLanguageQuery: String, completion: @escaping([MKMapItem]) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = naturalLanguageQuery
        
        if let region = searchRegion {
            request.region = region
        }
                
        let search = MKLocalSearch(request: request)
        
        search.start { response, error in
            guard let response = response else { return }
            completion(response.mapItems)
        }
    }
    
    func dismissLocationSearchViewController() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Search Bar Delegate

extension LocationSearchViewController: UISearchBarDelegate {
    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        print("DEBUG: Search bar text changed: \(searchText)..")
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        performQuery(with: searchBar.text)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        dismissLocationSearchViewController()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

// MARK: - Search Table View DataSource

extension LocationSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.reuseIdentifier, for: indexPath) as! SearchResultCell
        cell.placemark = searchResults[indexPath.row].placemark
        return cell
    }
}

// MARK: - Search Table View Delegate

extension LocationSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlacemark = searchResults[indexPath.row].placemark
        delegate?.didSelectLocation(with: selectedPlacemark)
        dismissLocationSearchViewController()
    }
}
