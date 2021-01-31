//
//  ProfileController.swift
//  LabsScaffolding
//
//  Created by Spencer Curtis on 7/23/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import OktaAuth
import UIKit

fileprivate let baseURL = URL(string: "https://resfeber-web-be.herokuapp.com/")!

class ProfileController {
    
    static let shared = ProfileController()
    
    typealias CompletionHandler<T: Decodable> = (Result<T, NetworkError>) -> Void
    
    // MARK: - Properties
        
    let oktaAuth = OktaAuth(baseURL: URL(string: "https://auth.lambdalabs.dev/")!,
                            clientID: "0oalwkxvqtKeHBmLI4x6",
                            redirectURI: "labs://scaffolding/implicit/callback")

    private(set) var authenticatedUserProfile: Profile?

    private(set) var profiles: [Profile] = []
    
    private var oktaCredentials: OktaCredentials? { try? oktaAuth.credentialsIfAvailable() }
        
    private var bearer: Bearer? {
        guard let credentials = oktaCredentials else { return nil }
        return Bearer(token: credentials.idToken)
    }
    
    private let router = Router()
    
    // MARK: - Init
    
    private init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshProfiles),
                                               name: .oktaAuthenticationSuccessful,
                                               object: nil)
    }

    // MARK: - Selectors
    
    @objc func refreshProfiles() {
        getAllProfiles { result in
            switch result {
            case .success(let profiles):
                self.profiles = profiles
            case .failure(let error):
                NSLog("Error fetching user profiles: \(error)")
            }
        }
    }
    
    // MARK: - API Requests
    
    func getAuthenticatedUserProfile(completion: @escaping () -> Void = {}) {
        getAuthenticatedUserProfile { _ in
            completion()
        }
    }

    private func getAuthenticatedUserProfile(completion: @escaping CompletionHandler<Profile>) {
        guard let oktaCredentials = oktaCredentials else {
            NSLog("Credentials do not exist. Unable to get authenticated user profile from API")
            completion(.failure(.noAuth))
            return
        }

        guard let userID = oktaCredentials.userID else {
            NSLog("User ID is missing.")
            completion(.failure(.noAuth))
            return
        }

        getProfile(userID) { result in
            switch result {
            case .success(let profile):
                self.authenticatedUserProfile = profile
            case .failure(let error):
                NSLog("Error getting authenticated user profile: \(error)")
            }
            completion(result)
        }
    }

    func checkForExistingAuthenticatedUserProfile(completion: @escaping (Bool) -> Void) {
        getAuthenticatedUserProfile {
            completion(self.authenticatedUserProfile != nil)
        }
    }
    
    func updateAuthenticatedUserProfile(_ profile: Profile, with name: String, email: String, avatarURL: URL, completion: @escaping (Profile) -> Void) {
        
        let userID = profile.id
        let updatedProfile = Profile(id: userID, email: email, name: name, avatarURL: avatarURL)

        guard var request = router.makeURLRequest(method: .put, endpointURL: Endpoints.profiles.url, bearer: bearer),
              let encodedProfile = encode(updatedProfile) else {
            completion(profile)
            return
        }
        request.httpBody = encodedProfile

        router.send(request) { error in
            if let error = error {
                NSLog("Error putting updated profile: \(error)")
                completion(profile)
                return
            }

            self.authenticatedUserProfile = updatedProfile
            completion(updatedProfile)
        }
    }

    // NOTE: This method is unused, but left as an example for creating a profile.
    func createProfile(with email: String, name: String, avatarURL: URL) -> Profile? {
        guard let oktaCredentials = oktaCredentials else {
            NSLog("Credentials do not exist. Unable to create a profile for the authenticated user")
            return nil
        }
        
        guard let userID = oktaCredentials.userID else {
            NSLog("User ID is missing.")
            return nil
        }
        
        return Profile(id: userID, email: email, name: name, avatarURL: avatarURL)
    }

    // NOTE: This method is unused, but left as an example for creating a profile on the scaffolding backend.
    func addProfile(_ profile: Profile, completion: @escaping () -> Void) {
        guard var request = router.makeURLRequest(method: .post, endpointURL: Endpoints.profiles.url, bearer: bearer),
              let encodedProfile = encode(profile) else {
            completion()
            return
        }
        request.httpBody = encodedProfile

        router.send(request) { error in
            if let error = error {
                NSLog("Error adding profile: \(error)")
                completion()
                return
            }

            self.profiles.append(profile)
            completion()
        }
    }

    func image(for url: URL, completion: @escaping (UIImage?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in

            var fetchedImage: UIImage?

            defer {
                DispatchQueue.main.async {
                    completion(fetchedImage)
                }
            }
            if let error = error {
                NSLog("Error fetching image for url: \(url.absoluteString), error: \(error)")
                return
            }

            guard let data = data, let image = UIImage(data: data) else { return }
            fetchedImage = image
        }
        dataTask.resume()
    }
}

        
//MARK: - Profile API

extension ProfileController {
    
    func getProfile(_ userID: String, completion: @escaping CompletionHandler<Profile>) {
        guard let request = router.makeURLRequest(method: .get, endpointURL: Endpoints.profileByUserId(userID).url, bearer: bearer) else {
            NSLog("Failed retrieving user ID from authenticated user profile.")
            completion(.failure(.badRequest))
            return
        }
        
        router.send(request) { result in
            completion(result)
        }
    }
    
    func getAllProfiles(completion: @escaping CompletionHandler<[Profile]>) {
        
        guard let request = router.makeURLRequest(method: .get, endpointURL: Endpoints.profiles.url, bearer: bearer) else {
            NSLog("Failed to GET all profiles from server: badRequest")
            completion(.failure(.badRequest))
            return
        }
        
        router.send(request) { (result: Result<[Profile], NetworkError>) in
            completion(result)
        }
    }
}


// MARK: - Private
    
extension ProfileController {
    
   private func encode<T: Encodable>(_ object: T) -> Data? {
        do {
            return try JSONEncoder().encode(object)
        } catch {
            NSLog("Error encoding JSON: \(error)")
            return nil
        }
    }
}


//MARK: -  Endpoints

extension ProfileController {
    
    /// The endpoints used to connect to the Resfeber backend API
    private enum Endpoints {
        case profileByUserId(String)
        case profiles
        
        var url: URL {
            switch self {
            case .profileByUserId(let userID):
                return baseURL.appendingPathComponent("profiles/\(userID)/")
            case .profiles:
                return baseURL.appendingPathComponent("profiles/")
            }
        }
    }
}


// MARK: - Notifications

extension ProfileController {
    private func postAuthenticationExpiredNotification() {
        NotificationCenter.default.post(name: .oktaAuthenticationExpired, object: nil)
    }
}
