//
//  RFWebService.swift
//  Resfeber
//
//  Created by David Wright on 1/20/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import UIKit
import OktaAuth

//fileprivate let baseURL = URL(string: "https://resfeber-27968.firebaseio.com/")!
fileprivate let baseURL = URL(string: "https://resfeber-web-be.herokuapp.com/")!

//MARK: - Properties

class RFWebService {
    
    typealias CompletionHandler<T: Decodable> = (Result<T, NetworkError>) -> Void
    
    private let profileController = ProfileController.shared
    
    private var bearer: Bearer? {
        guard let credentials = try? profileController.oktaAuth.credentialsIfAvailable() else { return nil }
        return Bearer(token: credentials.idToken)
    }
    
    private let router = Router()
}

//MARK: -  Endpoints

extension RFWebService {
    
    /// The endpoints used to connect to the Resfeber backend API
    private enum Endpoints {
        case tripsByUserId(String)
        case tripsAndItemsByUserId(String)
        case trips
        case itemsByUserIdAndTripId(userID: String, tripID: Int)
        case itemsByUserId(String)
        case items
        
        var url: URL {
            switch self {
            case .tripsByUserId(let userID):
                return baseURL.appendingPathComponent("trips/\(userID)/")
            case .tripsAndItemsByUserId(let userID):
                return baseURL.appendingPathComponent("trips/\(userID)/all/")
            case .trips:
                return baseURL.appendingPathComponent("trips/")
            case .itemsByUserIdAndTripId(let userID, let tripID):
                return baseURL.appendingPathComponent("trips/\(userID)/\(tripID)/")
            case .itemsByUserId(let userID):
                return baseURL.appendingPathComponent("items/\(userID)/")
            case .items:
                return baseURL.appendingPathComponent("items/")
            }
        }
    }
}

//MARK: -  Trip API

extension RFWebService {
    
    //MARK: - GET Trip
    
    func getTripsAndItems(completion: @escaping ([TripResultWithEvents]?) -> Void) {
        guard let userID = profileController.authenticatedUserProfile?.id else {
            NSLog("Error GETting trips and events from server: \(NetworkError.noAuth)")
            completion(nil)
            return
        }
        
        let endpointURL = Endpoints.tripsAndItemsByUserId(userID).url
        
        guard let request = router.makeURLRequest(method: .get, endpointURL: endpointURL, bearer: bearer) else {
            NSLog("Error GETting trips and events from server: \(NetworkError.badRequest)")
            completion(nil)
            return
        }
        
        router.send(request) { (result: Result<[TripResultWithEvents], NetworkError>) in
            switch result {
            
            case .success(let tripWithEventsResult):
                let tripsDescription = tripWithEventsResult.isEmpty ? "[]" : "[\"\(tripWithEventsResult.map { $0.name }.joined(separator: "\", \""))]\""
                let eventCount = tripWithEventsResult.compactMap {$0.events?.count}.reduce(0,+)
                print("Successful GET request of all trips and events from server: tripCount = \(tripWithEventsResult.count), eventCount = \(eventCount), \(tripsDescription)")
                completion(tripWithEventsResult)
                
            case .failure(let error):
                NSLog("Error GETting trips and events from server: \(error)")
                completion(nil)
            }
        }
    }
    
    //MARK: - POST Trip
    
    func postTrip(_ trip: Trip, completion: @escaping (TripResult?) -> Void) {
        
        let endpointURL = Endpoints.trips.url
        
        guard let request = router.makeURLRequest(method: .post, endpointURL: endpointURL, object: trip.tripPOSTRequest, bearer: bearer) else {
            NSLog("Error POSTing trip \"\(trip.name ?? "")\" to server: \(NetworkError.badRequest)")
            completion(nil)
            return
        }
        
        router.send(request) { (result: Result<[TripResult], NetworkError>) in
            switch result {

            case .success(let tripResultArray):
                guard let tripResult = tripResultArray.first else {
                    NSLog("Error POSTing trip \"\(trip.name ?? "")\" to server: \(NetworkError.noData)")
                    completion(nil)
                    return
                }
                
                guard tripResult.serverID != nil else {
                    NSLog("Error POSTing trip \"\(trip.name ?? "")\" to server: `tripResult` in network response is missing a serverID")
                    completion(nil)
                    return
                }
                
                print("Successfully POSTed trip \"\(trip.name ?? "")\" to server: serverID = \(tripResult.serverID!)")
                completion(tripResult)
                
            case .failure(let error):
                NSLog("Error POSTing trip \"\(trip.name ?? "")\" to server: \(error)")
            }
            
            completion(nil)
        }
    }
    
    //MARK: - PUT Trip
    
    func putTrip(_ trip: Trip, completion: @escaping (TripResult?) -> Void = { _ in }) {
        
        let endpointURL = Endpoints.trips.url
        
        guard let request = router.makeURLRequest(method: .put, endpointURL: endpointURL, object: trip.tripResult, bearer: bearer) else {
            NSLog("Error PUTing trip \"\(trip.name ?? "")\" to server: \(NetworkError.badRequest)")
            return
        }
        
        router.send(request) { (result: Result<[TripResult], NetworkError>) in
            switch result {

            case .success(let tripResultArray):
                if let tripResult = tripResultArray.first {
                    print("Successfully PUT trip \"\(tripResult.name)\" to server")
                    completion(tripResult)
                    return
                } else {
                    NSLog("Error PUTing trip \"\(trip.name ?? "")\" to server: \(NetworkError.noData)")
                }

            case .failure(let error):
                NSLog("Error PUTing trip \"\(trip.name ?? "")\" to server: \(error)")
            }
            
            completion(nil)
        }
    }
    
    //MARK: - DELETE Trip
    
    func deleteTrip(_ trip: Trip, completion: @escaping (Bool) -> Void = { _ in }) {
        
        let group = DispatchGroup()
        group.enter()
        
        for event in trip.eventsArray {
            group.enter()
            deleteEvent(event) { _ in
                group.leave()
            }
        }
        group.leave()
        
        group.notify(queue: .main) {
            
            let endpointURL = Endpoints.trips.url
            
            guard let request = self.router.makeURLRequest(method: .delete, endpointURL: endpointURL, object: trip.tripResult, bearer: self.bearer) else {
                NSLog("Error DELETEing trip \"\(trip.name ?? "")\" from server: \(NetworkError.badRequest)")
                completion(false)
                return
            }
            
            self.router.self.send(request) { error in
                if let error = error {
                    NSLog("Error DELETEing trip \"\(trip.name ?? "")\" from server: \(error)")
                    completion(false)
                    return
                }
                
                print("Successfully DELETEed trip \"\(trip.name ?? "")\" from server")
                completion(true)
            }
        }
    }
}

//MARK: -  Event API

extension RFWebService {
    
    //MARK: - GET Event
    
    func getEvents(forTripID tripID: Int, completion: @escaping ([EventResult]?) -> Void) {
        guard let userID = profileController.authenticatedUserProfile?.id else {
            NSLog("Error GETting eventResults for tripID: \"\(tripID)\" from server: \(NetworkError.noAuth)")
            completion(nil)
            return
        }
        
        let endpointURL = Endpoints.itemsByUserIdAndTripId(userID: userID, tripID: tripID).url
        
        guard let request = router.makeURLRequest(method: .get, endpointURL: endpointURL, bearer: bearer) else {
            NSLog("Error GETting eventResults for tripID: \"\(tripID)\" from server: \(NetworkError.badRequest)")
            completion(nil)
            return
        }
        
        router.send(request) { (result: Result<[EventResult], NetworkError>) in
            switch result {
            
            case .success(let eventResults):
                let eventsDescription = eventResults.isEmpty ? "[]" : "[\"\(eventResults.map { $0.name }.joined(separator: "\", \""))]\""
                print("Successful GET request of eventResults from server for tripID: \"\(tripID)\": \(eventsDescription)")
                completion(eventResults)
            
            case .failure(let error):
                NSLog("Error GETting eventResults from server for tripID: \"\(tripID)\": \(error)")
                completion(nil)
            }
        }
    }
    
    //MARK: - POST Event
    
    func postEvent(_ event: Event, completion: @escaping (EventResult?) -> Void) {
        
        let eventPOSTRequest = event.eventPOSTRequest
        let endpointURL = Endpoints.items.url
        
        guard let request = router.makeURLRequest(method: .post, endpointURL: endpointURL, object: eventPOSTRequest, bearer: bearer) else {
            NSLog("Error POSTing event \"\(event.name ?? "")\" to server: \(NetworkError.badRequest)")
            completion(nil)
            return
        }
        
        router.send(request) { (result: Result<[EventResult], NetworkError>) in
            switch result {

            case .success(let eventResultArray):
                guard let eventResult = eventResultArray.first else {
                    NSLog("Error POSTing event \"\(event.name ?? "")\" to server: \(NetworkError.noData)")
                    completion(nil)
                    return
                }
                
                guard eventResult.serverID != nil else {
                    NSLog("Error POSTing event \"\(event.name ?? "")\" to server: `eventResult` in network response is missing a serverID")
                    completion(nil)
                    return
                }
                
                print("Successfully POSTed event \"\(event.name ?? "")\" to server: serverID = \(eventResult.serverID!)")
                completion(eventResult)
                
            case .failure(let error):
                NSLog("Error POSTing event \"\(event.name ?? "")\" to server: \(error)")
            }
            
            completion(nil)
        }
    }
    
    //MARK: - PUT Event
    
    func putEvent(_ event: Event, completion: @escaping (EventResult?) -> Void = { _ in }) {
        
        let eventResult = event.eventResult
        let endpointURL = Endpoints.items.url
        
        guard let request = router.makeURLRequest(method: .put, endpointURL: endpointURL, object: eventResult, bearer: bearer) else {
            NSLog("Error PUTing event \"\(event.name ?? "")\" for trip \"\(event.trip?.name ?? "")\" to server: \(NetworkError.badRequest)")
            completion(nil)
            return
        }
        
        router.send(request) { (result: Result<[EventResult], NetworkError>) in
            switch result {

            case .success(let eventResultArray):
                if let eventResult = eventResultArray.first {
                    print("Successfully PUT event \"\(eventResult.name)\" for trip \"\(event.trip?.name ?? "")\" to server")
                    completion(eventResult)
                    return
                } else {
                    NSLog("Error PUTing event \"\(event.name ?? "")\" for trip \"\(event.trip?.name ?? "")\" to server: \(NetworkError.noData)")
                }

            case .failure(let error):
                NSLog("Error PUTing event \"\(event.name ?? "")\" for trip \"\(event.trip?.name ?? "")\" to server: \(error)")
            }
            
            completion(nil)
        }
    }
    
    //MARK: - DELETE Event
    
    func deleteEvent(_ event: Event, completion: @escaping (Bool) -> Void = { _ in }) {
        
        let eventResult = event.eventResult
        let endpointURL = Endpoints.items.url
        
        guard let request = router.makeURLRequest(method: .delete, endpointURL: endpointURL, object: eventResult, bearer: bearer) else {
            NSLog("Error DELETEing event \"\(event.name ?? "")\" from server: \(NetworkError.badRequest)")
            completion(false)
            return
        }
        
        router.send(request) { (error: NetworkError?) in
            if let error = error {
                NSLog("Error DELETEing event \"\(event.name ?? "")\" from trip \"\(event.trip?.name ?? "")\" on server: \(error)")
                completion(false)
                return
            }
            
            print("Successfully DELETEed event \"\(event.name ?? "")\" from trip \"\(event.trip?.name ?? "")\" on server")
            completion(true)
        }
    }
}
