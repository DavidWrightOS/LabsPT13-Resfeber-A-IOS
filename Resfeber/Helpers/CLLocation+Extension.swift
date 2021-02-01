//
//  CLLocation+Extension.swift
//  Resfeber
//
//  Created by David Wright on 12/14/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import CoreLocation

extension CLLocation {
    func fetchPlacemark(completion: @escaping (CLPlacemark?) -> ()) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(self) { placemarks, error in
            if let error = error {
                NSLog("Error generating address from CLLocation coordinates: \(error)")
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            guard let placemark = placemarks?.first else {
                NSLog("Error generating address from CLLocation coordinates")
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            DispatchQueue.main.async { completion(placemark) }
        }
    }
    
    func fetchAddress(completion: @escaping (String?) -> ()) {
        fetchPlacemark { placemark in
            completion(placemark?.address)
        }
    }
}
