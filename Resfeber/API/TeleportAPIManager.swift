//
//  TeleportAPIManager.swift
//  Resfeber
//
//  Created by Joshua Rutkowski on 11/13/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

class TeleportAPIManager {
    /// The Base URL for connecting with the Teleport json endpoint
    let baseURL = URL(string: "https://api.teleport.org/api")!
    
    /// The default Headers for connecting with the Teleport json endpoint
    var defaultHeaders = [
        "Accept" : "application/vnd.teleport.v1+json",
        "Content-Type" : "application/json; charset=utf-8"
    ]
    
    // MARK: - Endpoints
    /// The endpoints used to connect to the Teleport API
    enum Endpoints {
        case citybyName(String)
        case citiesByID(String)
        case citiesAlternateNames(String)
        case urbanAreas
        case urbanAreasByID(String)
        case urbanAreasCities(String)
        case urbanAreasDetails(String)
        case urbanAreasImages(String)
        case urbanAreasScores(String)
        case locationsByCoordinates(String)
    }
    
    // MARK: - Methods
    
    /// Method to search for a city by name. Returns matching cities and endpoints.
    /// - Parameters:
    ///   - name: Name of city
    ///   - session: URLSession
    private func searchCity(byName name: String, using session: URLSession = .shared) {
        session.request(TeleportAPIManager.Endpoints.citybyName(name)) { data, response, error  in
            
            if error != nil || data == nil {
                print("Client error: \(String(describing: error?.localizedDescription))")
                return
            }
        
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error: \(String(describing: error?.localizedDescription))")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print(json)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
    }
    
    /// Method that returns information for a given city based on the unique identifier.
    /// Information includes full name, geoname ID, location, population, and endpoints for related information
    /// - Parameters:
    ///   - ID: String for a city ID. Example: "geonameid:1796236"
    ///   - session: URLSession
    private func getCity(byID ID: String, using session: URLSession = .shared) {
        session.request(TeleportAPIManager.Endpoints.citiesByID(ID)) { (data, response, error) in
            if error != nil || data == nil {
                print("Client error: \(String(describing: error?.localizedDescription))")
                return
            }
        
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print(json)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
    }
    
    /// Method that returns alternate names for a given city.
    /// - Parameters:
    ///   - ID: String for a city ID. Example: "geonameid:1796236"
    ///   - session: URLSession
    private func getCityAlternateName(byID ID: String, using session: URLSession = .shared) {
        session.request(TeleportAPIManager.Endpoints.citiesAlternateNames(ID)) { (data, response, error) in
            if error != nil || data == nil {
                print("Client error: \(String(describing: error?.localizedDescription))")
                return
            }
        
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print(json)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
    }
    
    /// Method to get return all Urban Area endpoints and names
    /// - Parameter session: URL Session
    private func getAllUrbanAreas(using session: URLSession = .shared) {
        session.request(TeleportAPIManager.Endpoints.urbanAreas) { (data, response, error) in
            if error != nil || data == nil {
                print("Client error: \(String(describing: error?.localizedDescription))")
                return
            }
        
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print(json)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
    }
    
    /// Method to return information on a specific Urban Area
    /// - Parameters:
    ///   - ID: Unique ID for urban aream. Example: "teleport:swbb5"
    ///   - session: URLSession
    private func getUrbanArea(byID ID: String, using session: URLSession) {
        session.request(TeleportAPIManager.Endpoints.urbanAreasByID(ID)) { (data, response, error) in
            if error != nil || data == nil {
                print("Client error: \(String(describing: error?.localizedDescription))")
                return
            }
        
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print(json)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
    }
    
    /// Method to return details for a specific Urban Area
    /// - Parameters:
    ///   - ID: Unique ID for urban area. Example: "teleport:swbb5"
    ///   - session: URLSession
    private func getUrbanAreaDetails(byID ID: String, using session: URLSession) {
        session.request(TeleportAPIManager.Endpoints.urbanAreasDetails(ID)) { (data, response, error) in
            if error != nil || data == nil {
                print("Client error: \(String(describing: error?.localizedDescription))")
                return
            }
        
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print(json)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
    }

    /// Method to return images for a specific Urban Area
    /// - Parameters:
    ///   - ID: Unique ID for urban area. Example: "teleport:swbb5"
    ///   - session: URLSession
    private func getUrbanAreaImages(byID ID: String, using session: URLSession) {
        session.request(TeleportAPIManager.Endpoints.urbanAreasImages(ID)) { (data, response, error) in
            if error != nil || data == nil {
                print("Client error: \(String(describing: error?.localizedDescription))")
                return
            }
        
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print(json)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
    }

    /// Method to return scores for a specific Urban Area in areas such as Cost of Living, Outdoors, Leisure.
    /// - Parameters:
    ///   - ID: Unique ID for urban area. Example: "teleport:swbb5"
    ///   - session: URLSession
    private func getUrbanAreaScores(byID ID: String, using session: URLSession) {
        session.request(TeleportAPIManager.Endpoints.urbanAreasScores(ID)) { (data, response, error) in
            if error != nil || data == nil {
                print("Client error: \(String(describing: error?.localizedDescription))")
                return
            }
        
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print(json)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
    }
    
    
}

//MARK: -  Extensions

extension TeleportAPIManager.Endpoints {
    /// Endpoint URL
    var url: URL {
        switch self {
        case .citybyName(let city):
            return .makeEndpoint("cities/?search=\(city)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "/cities/?search=\(city)")
        case .citiesByID(let cityID):
            return .makeEndpoint("cities/\(cityID)/")
        case .citiesAlternateNames(let cityName):
            return .makeEndpoint("cities/\(cityName)/")
        case .urbanAreas:
            return .makeEndpoint("urban_areas/")
        case .urbanAreasByID(let urbanAreaID):
            return .makeEndpoint("urban_areas/\(urbanAreaID)/")
        case .urbanAreasCities(let urbanAreaID):
            return .makeEndpoint("urban_areas/\(urbanAreaID)/cities/")
        case .urbanAreasDetails(let urbanAreaID):
            return .makeEndpoint("urban_areas/\(urbanAreaID)/details/")
        case .urbanAreasImages(let urbanAreaID):
            return .makeEndpoint("urban_areas/\(urbanAreaID)/images/")
        case .urbanAreasScores(let urbanAreaID):
            return .makeEndpoint("urban_areas/\(urbanAreaID)/scores/")
        case .locationsByCoordinates(let coordinates):
            return .makeEndpoint("locations/\(coordinates)/")
        }
    }
}

extension URL {
    /// Extension of URL to make endpoint from a specified URL and endpoint
    /// - Parameter endpoint: An API endpoint
    /// - Returns: baseURL and endpoint
    static func makeEndpoint(_ endpoint: String) -> URL {
        URL(string: "https://api.teleport.org/api/\(endpoint)")!
    }
}

extension URLSession {
    typealias Handler = (Data?, URLResponse?, Error?) -> Void
    
    /// Method that accepts an Endpoint to call and starts a datatask
    /// - Parameters:
    ///   - endpoint: an endpoint for API call
    ///   - handler: a completion handler that returns data, response, and an error
    /// - Returns: data task
    @discardableResult
    func request( _ endpoint: TeleportAPIManager.Endpoints,
                  then handler: @escaping Handler) -> URLSessionDataTask {
        let task = dataTask(with: endpoint.url, completionHandler: handler)
        task.resume()
        return task
    }
}


