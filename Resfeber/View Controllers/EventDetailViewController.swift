//
//  EventDetailViewController.swift
//  Resfeber
//
//  Created by David Wright on 12/22/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import CoreData
import MapKit

protocol EventDetailViewControllerDelegate: class {
    func didAddEvent(_ event: Event)
    func didUpdateEvent(_ event: Event)
}

class EventDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var event: Event? {
        didSet {
            updateViews()
        }
    }
    
    weak var delegate: EventDetailViewControllerDelegate?
    
    private let tripsController: TripsController
    
    private let trip: Trip
    
    private let mapView = MKMapView()
    
    private var shouldEnableAddEventButton: Bool {
        placemark != nil
    }
    
    private var shouldEnableSaveEventButton: Bool {
        guard let event = event else { return false }
        
        return !(eventName == event.name &&
                 placemark?.address == event.address &&
                 category == event.category &&
                 startDate == event.startDate &&
                 endDate == event.endDate &&
                 notes == event.notes)
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.alwaysBounceVertical = false
        tableView.backgroundColor = RFColor.background
        tableView.tableFooterView = UIView()
        tableView.register(TextInputCell.self, forCellReuseIdentifier: TextInputCell.reuseIdentifier)
        tableView.register(LocationInputCell.self, forCellReuseIdentifier: LocationInputCell.reuseIdentifier)
        tableView.register(CategoryInputCell.self, forCellReuseIdentifier: CategoryInputCell.reuseIdentifier)
        tableView.register(DateInputCell.self, forCellReuseIdentifier: DateInputCell.reuseIdentifier)
        tableView.register(TextViewInputCell.self, forCellReuseIdentifier: TextViewInputCell.reuseIdentifier)
        return tableView
    }()
    
    private weak var firstResponder: UIView? {
        didSet {
            oldValue?.resignFirstResponder()
            firstResponder?.becomeFirstResponder()
        }
    }
    
    // Trip attributes
    
    private var eventName: String?
    
    private var placemark: MKPlacemark? {
        didSet {
            reloadMapAnnotation()
        }
    }
    private var locationName: String?
    private var address: String?
    private var category: EventCategory?
    private var notes: String?
    private var startDate: Date?
    private var endDate: Date?
    
    // MARK: - Lifecycle
    
    init(trip: Trip, tripsController: TripsController) {
        self.trip = trip
        self.tripsController = tripsController
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(trip: Trip, tripsController: TripsController, placemark: MKPlacemark) {
        self.init(trip: trip, tripsController: tripsController)
        self.placemark = placemark
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }

    // MARK: - Helpers
    
    private func configureViews() {
        view.backgroundColor = RFColor.background
        
        // Configure Navigation Bar
        
        navigationController?.navigationBar.tintColor = RFColor.red
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(addNewEventWasCancelled))
        configureRightBarButton()
        title = event != nil ? "Edit Event" : "New Event"
        
        // Configure MapView
        
        mapView.layer.borderWidth = 1
        mapView.layer.borderColor = UIColor.separator.withAlphaComponent(0.15).cgColor
        view.addSubview(mapView)
        mapView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                       left: view.leftAnchor,
                       right: view.rightAnchor,
                       paddingTop: 4,
                       height: view.frame.width * 0.8)
        
        // Configure TableView
        
        tableView.delegate = self
        tableView.dataSource = self
        view.insertSubview(tableView, at: 0)
        tableView.anchor(top: mapView.bottomAnchor,
                         left: view.leftAnchor,
                         bottom: view.bottomAnchor,
                         right: view.rightAnchor,
                         paddingTop: -24)
        
        // If creating a new event, set first responder
        
        if event == nil, let indexPath = getIndexPath(section: .nameAndLocation, row: NameAndLocationInputRow.name) {
            firstResponder = tableView.cellForRow(at: indexPath)
        }
        
        reloadMapAnnotation()
    }
    
    private func reloadMapAnnotation() {
        mapView.removeAnnotations(mapView.annotations)
        
        if let placemark = placemark {
            mapView.addAnnotation(placemark)
        }
        
        mapView.zoomToFit(animated: false)
    }
    
    private func configureRightBarButton() {
        if event != nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                                style: .done,
                                                                target: self,
                                                                action: #selector(updateEvent))
            navigationItem.rightBarButtonItem?.isEnabled = shouldEnableSaveEventButton
            
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                                style: .done,
                                                                target: self,
                                                                action: #selector(newEventWasSaved))
            navigationItem.rightBarButtonItem?.isEnabled = shouldEnableAddEventButton
        }
    }
    
    private func updateViews() {
        guard let event = event else { return }
        
        title = "Edit Event"
        
        loadLocationFromEvent()
        
        eventName = event.name
        locationName = event.locationName
        address = event.address
        category = event.category
        notes = event.notes
        startDate = event.startDate
        endDate = event.endDate
        
        tableView.reloadData()
    }
    
    private func loadLocationFromEvent() {
        guard let lat = event?.latitude, let lon = event?.longitude else { return }
        
        let location = CLLocation(latitude: lat, longitude: lon)
        
        location.fetchPlacemark { [weak self] placemark in
            guard let self = self,
                  let placemark = placemark,
                  let indexPath = self.getIndexPath(section: AddEventSection.nameAndLocation,
                                                    row: NameAndLocationInputRow.location) else { return }
            
            self.placemark = MKPlacemark(placemark: placemark)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: - Selectors

    @objc func didUpdateStartDate() {
        let startDateIndexPath = IndexPath(row: DateInputRow.startDate.rawValue, section: AddEventSection.dates.rawValue)
        tableView.reloadRows(at: [startDateIndexPath], with: .automatic)
        
        guard let startDate = startDate else { return }
        
        let endDateIndexPath = IndexPath(row: DateInputRow.endDate.rawValue, section: AddEventSection.dates.rawValue)
        guard let endDateCell = tableView.cellForRow(at: endDateIndexPath) as? DateInputCell else { return }
        
        if let endDate = endDate {
            let eventDuration = startDate.distance(to: endDate)
            self.endDate = startDate.advanced(by: eventDuration)
            tableView.reloadRows(at: [endDateIndexPath], with: .automatic)
        } else {
            endDateCell.setDatePickerDate(startDate)
        }
    }

    @objc func didUpdateEndDate() {
        let endDateIndexPath = IndexPath(row: DateInputRow.endDate.rawValue, section: AddEventSection.dates.rawValue)
        tableView.reloadRows(at: [endDateIndexPath], with: .automatic)
        
        guard let endDate = endDate else { return }
        
        let startDateIndexPath = IndexPath(row: DateInputRow.startDate.rawValue, section: AddEventSection.dates.rawValue)
        guard let startDateCell = tableView.cellForRow(at: startDateIndexPath) as? DateInputCell else { return }
                
        if let startDate = startDate {
            let eventDuration = startDate.distance(to: endDate)
            self.startDate = endDate.advanced(by: -eventDuration)
            tableView.reloadRows(at: [startDateIndexPath], with: .automatic)
        } else {
            startDateCell.setDatePickerDate(endDate)
        }
    }
    
    @objc func presentLocationSearchViewController() {
        let locationSearchVC = LocationSearchViewController()
        locationSearchVC.delegate = self
        
        if let region = trip.eventsCoordinateRegion {
            locationSearchVC.searchRegion = region
        }
        
        present(locationSearchVC, animated: true, completion: nil)
    }
    
    @objc func addNewEventWasCancelled() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func newEventWasSaved() {
        guard let placemark = placemark,
              let latitude = placemark.location?.coordinate.latitude,
              let longitude = placemark.location?.coordinate.longitude else { return }
        
        let locationName = self.locationName ?? placemark.name
        let address = self.address ?? placemark.address
        
        let name: String?
        if let eventName = eventName, !eventName.isEmpty {
            name = eventName
        } else {
            name = locationName
        }
        
        let event = tripsController.addEvent(name: name,
                                             locationName: locationName,
                                             category: category,
                                             latitude: latitude,
                                             longitude: longitude,
                                             address: address,
                                             startDate: startDate,
                                             endDate: endDate,
                                             notes: notes,
                                             trip: trip)
        
        delegate?.didAddEvent(event)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func updateEvent() {
        guard let event = event,
              let placemark = placemark,
              let latitude = placemark.location?.coordinate.latitude,
              let longitude = placemark.location?.coordinate.longitude else { return }
        
        if let eventName = eventName, !eventName.isEmpty {
            event.name = eventName
        } else {
            event.name = locationName
        }
        
        event.category = category ?? .notSpecified
        event.locationName = locationName ?? placemark.name
        event.latitude = latitude
        event.longitude = longitude
        event.address = address ?? placemark.address
        event.startDate = startDate
        event.endDate = endDate
        event.notes = notes
        
        tripsController.updateEvent(event)
        
        delegate?.didUpdateEvent(event)
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Location Search ViewController Delegate

extension EventDetailViewController: LocationSearchViewControllerDelegate {
    
    func didSelectLocation(with placemark: MKPlacemark) {
        self.placemark = placemark
        updateLocationDescription(with: placemark)
        dropPinAndZoomIn(placemark: placemark)
    }
    
    private func updateLocationDescription(with placemark: MKPlacemark) {
        mapView.removeAnnotations(mapView.annotations)
        let indexPath = IndexPath(row: NameAndLocationInputRow.location.rawValue, section: AddEventSection.nameAndLocation.rawValue)
        let cell = tableView.cellForRow(at: indexPath) as? LocationInputCell
        cell?.placemark = placemark
    }
    
    private func dropPinAndZoomIn(placemark: MKPlacemark) {
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = locationName ?? placemark.name
        
        if let address = address ?? placemark.address {
            annotation.subtitle = address
        }
        
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}

// MARK: - UITableView Data Source

extension EventDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        AddEventSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = AddEventSection(rawValue: section) else { return 0 }
        return section.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = AddEventSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .nameAndLocation:
            guard let row = section.rows[indexPath.row] as? NameAndLocationInputRow else { return UITableViewCell() }
            switch row {
            case .name:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TextInputCell.reuseIdentifier, for: indexPath) as? TextInputCell else { return UITableViewCell() }
                cell.delegate = self
                cell.placeholder = row.placeholderText
                cell.inputText = eventName
                return cell
                
            case .location:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationInputCell.reuseIdentifier, for: indexPath) as? LocationInputCell else { return UITableViewCell() }
                cell.delegate = self
                cell.placeholder = row.placeholderText
                if let event = event {
                    cell.locationName = event.locationName
                    cell.address = event.address
                } else {
                    cell.placemark = placemark
                }
                return cell
            }
            
        case .category:
            guard let row = section.rows[indexPath.row] as? CategoryInputRow else { return UITableViewCell() }
            switch row {
            case .category:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryInputCell.reuseIdentifier, for: indexPath) as? CategoryInputCell else { return UITableViewCell() }
                cell.delegate = self
                cell.attributeTitle = row.attributeTitle
                cell.placeholder = row.placeholderText
                cell.category = category
                return cell
            }
            
        case .dates:
            guard let row = section.rows[indexPath.row] as? DateInputRow else { return UITableViewCell() }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DateInputCell.reuseIdentifier, for: indexPath) as? DateInputCell else { return UITableViewCell() }
            cell.delegate = self
            cell.attributeTitle = row.attributeTitle
            cell.placeholder = row.placeholderText
            switch row {
            case .startDate:
                cell.date = startDate
            case .endDate:
                cell.date = endDate
            }
            return cell
            
        case .notes:
            guard let row = section.rows[indexPath.row] as? NotesInputRow else { return UITableViewCell() }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextViewInputCell.reuseIdentifier, for: indexPath) as? TextViewInputCell else { return UITableViewCell() }
            switch row {
            case .notes:
                cell.delegate = self
                cell.placeholder = row.placeholderText
                cell.inputText = notes
                return cell
            }
        }
    }
}


// MARK: - UITableView Delegate

extension EventDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = RFColor.background
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textColor = UIColor.secondaryLabel
        label.text = AddEventSection(rawValue: section)?.headerText?.uppercased()
        
        view.addSubview(label)
        label.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                     left: view.safeAreaLayoutGuide.leftAnchor,
                     bottom: view.safeAreaLayoutGuide.bottomAnchor,
                     right: view.safeAreaLayoutGuide.rightAnchor,
                     paddingTop: 8,
                     paddingLeft: 16,
                     paddingBottom: 4,
                     paddingRight: 16)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = RFColor.background
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textColor = UIColor.secondaryLabel
        label.text = AddEventSection(rawValue: section)?.footerText
        
        view.addSubview(label)
        label.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                     left: view.safeAreaLayoutGuide.leftAnchor,
                     bottom: view.safeAreaLayoutGuide.bottomAnchor,
                     right: view.safeAreaLayoutGuide.rightAnchor,
                     paddingTop: 4,
                     paddingLeft: 16,
                     paddingBottom: 8,
                     paddingRight: 16)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = section(at: indexPath) else { return }
        firstResponder = tableView.cellForRow(at: indexPath)
        
        switch section {
        case .nameAndLocation:
            guard let row = inputRow(at: indexPath) as? NameAndLocationInputRow else { return }
            switch row {
            case .location:
                presentLocationSearchViewController()
            default:
                break
            }
        default:
            break
        }
    }
    
    func section(at indexPath: IndexPath) -> AddEventSection? {
        AddEventSection(rawValue: indexPath.section)
    }
    
    func inputRow(at indexPath: IndexPath) -> InputRow? {
         section(at: indexPath)?.rows[indexPath.row]
    }
    
    func getIndexPath(section: AddEventSection, row: InputRow) -> IndexPath? {
        switch section {
        case .nameAndLocation:
            guard let inputRow = row as? NameAndLocationInputRow else { return nil }
            return IndexPath(row: inputRow.rawValue, section: section.rawValue)
        case .category:
            guard let inputRow = row as? CategoryInputRow else { return nil }
            return IndexPath(row: inputRow.rawValue, section: section.rawValue)
        case .dates:
            guard let inputRow = row as? DateInputRow else { return nil }
            return IndexPath(row: inputRow.rawValue, section: section.rawValue)
        case .notes:
            guard let inputRow = row as? NotesInputRow else { return nil }
            return IndexPath(row: inputRow.rawValue, section: section.rawValue)
        }
    }
}

extension EventDetailViewController: EventDetailCellDelegate {
    
    func didUpdateData(forCell cell: EventDetailCell) {
        guard let indexPath = tableView.indexPath(for: cell),
              let section = section(at: indexPath) else { return }
        
        switch section {
        case .nameAndLocation:
            guard let row = inputRow(at: indexPath) as? NameAndLocationInputRow else { return }
            switch row {
            case .name:
                guard let cell = cell as? TextInputCell else { return }
                self.eventName = cell.inputText
            case .location:
                guard let cell = cell as? LocationInputCell else { return }
                self.locationName = cell.locationName
                self.address = cell.address
                self.placemark = cell.placemark
            }
        
        case .notes:
            guard let row = inputRow(at: indexPath) as? NotesInputRow else { return }
            switch row {
            case .notes:
                guard let cell = cell as? TextViewInputCell else { return }
                self.notes = cell.inputText
            }
            
        case .category:
            guard let row = inputRow(at: indexPath) as? CategoryInputRow else { return }
            switch row {
            case .category:
                guard let cell = cell as? CategoryInputCell else { return }
                self.category = cell.category
            }
            
        case .dates:
            guard let row = inputRow(at: indexPath) as? DateInputRow,
                   let cell = cell as? DateInputCell else { return }
            switch row {
            case .startDate:
                self.startDate = cell.date
            case .endDate:
                self.endDate = cell.date
            }
        }
        
        navigationItem.rightBarButtonItem?.isEnabled = event == nil ? shouldEnableAddEventButton : shouldEnableSaveEventButton
    }
}

// MARK: - Map View Delegate

extension EventDetailViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Event.annotationReuseIdentifier, for: annotation) as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: Event.annotationReuseIdentifier)
        }
        
        annotationView?.glyphImage = category?.annotationGlyph
        annotationView?.markerTintColor = category?.annotationMarkerTintColor
        annotationView?.animatesWhenAdded = true
        
        return annotationView
    }
}
