//
//  Router.swift
//  Resfeber
//
//  Created by David Wright on 1/30/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation

class Router {
    
    func send<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            var completionData: Result<T, NetworkError>
            
            defer {
                DispatchQueue.main.async {
                    completion(completionData)
                }
            }
            
            if let error = error {
                NSLog("Error fetching data from API: \(error)")
                completionData = .failure(.unableToComplete)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                NSLog("Error: Unexpected status code HTTP \(response.statusCode)")
                completionData = .failure(.invalidResponse)
                return
            }
            
            guard let data = data else {
                NSLog("Error: No data returned from API")
                completionData = .failure(.noData)
                return
            }
            
            guard T.self != Data.self else {
                completionData = .success(data as! T)
                return
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completionData = .success(decodedObject)
            } catch {
                NSLog("Error: Unable to decode data from API: \(error)")
                completionData = .failure(.decodingError)
            }
            
        }.resume()
    }
    
    func send(_ request: URLRequest, completion: @escaping (NetworkError?) -> Void) {
        URLSession.shared.dataTask(with: request) { _, response, error in
            var completionData: NetworkError?
            
            defer {
                DispatchQueue.main.async {
                    completion(completionData)
                }
            }
            
            if let error = error {
                NSLog("Error fetching data from API: \(error)")
                completionData = .unableToComplete
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                NSLog("Error: Unexpected status code HTTP \(response.statusCode)")
                completionData = .invalidResponse
                return
            }
            
        }.resume()
    }
}


extension Router {
    
    func makeURLRequest(method httpMethod: HTTPMethod, endpointURL: URL, bearer: Bearer? = nil) -> URLRequest? {
        
        var request = URLRequest(url: endpointURL)
        request.httpMethod = httpMethod.rawValue
        
        if let bearerToken = bearer?.token {
            request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    
    func makeURLRequest<T: Encodable>(method httpMethod: HTTPMethod, endpointURL: URL, object: T, bearer: Bearer? = nil) -> URLRequest? {
        
        guard var request = makeURLRequest(method: httpMethod, endpointURL: endpointURL, bearer: bearer) else { return nil }
        
        do {
            request.httpBody = try JSONEncoder().encode(object)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch (let error) {
            NSLog("Failed to encode object for request: \(endpointURL.absoluteString): \(error)")
            return nil
        }
        
        return request
    }
    
    func makeURLRequest<T: Encodable>(method httpMethod: HTTPMethod, endpointURL: URL, parameters: [String: T], bearer: Bearer? = nil) -> URLRequest? {
        
        guard var request = makeURLRequest(method: httpMethod, endpointURL: endpointURL, bearer: bearer) else { return nil }
        
        do {
            request.httpBody = try JSONEncoder().encode(parameters)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch (let error) {
            NSLog("Failed to encode parameters for request: \(endpointURL.absoluteString): \(error)")
            return nil
        }
        
        return request
    }
}


//extension Data {
//    func printAsJSON() {
//        guard let dict = try? JSONSerialization.jsonObject(with: self) as? Dictionary<String, Any>,
//              let JSONData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
//              let JSONString = String(data: JSONData, encoding: .utf8) else {
//            print("Unable to print JSON to the console: Error decoding and/or encoding Data")
//            return
//        }
//        print(JSONString)
//    }
//}
//
//public extension Dictionary {
//    func printAsJSON() {
//        guard let JSONData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted),
//              let JSONString = String(data: JSONData, encoding: .utf8) else {
//            print("Unable to print JSON to the console: Error encoding Dictionary")
//            return
//        }
//        print(JSONString)
//    }
//}
//
//func printAsJSON<T: Encodable>(object: T) {
//    guard let JSONData = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted),
//       let JSONString = String(data: JSONData, encoding: .utf8) else {
//        print("Unable to print JSON to the console: Error encoding object")
//        return
//    }
//    print(JSONString)
//}
