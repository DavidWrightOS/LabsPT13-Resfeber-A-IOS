//
//  CLPlacemark+Extension.swift
//  Resfeber
//
//  Created by David Wright on 12/14/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import CoreLocation

extension CLPlacemark {
    var address: String? {
        guard let subThoroughfare = subThoroughfare,
              let thoroughfare = thoroughfare,
              let locality = locality,
              let adminArea = administrativeArea,
              let postalCode = postalCode else { return nil }
        
        return "\(subThoroughfare) \(thoroughfare), \(locality), \(adminArea) \(postalCode)"
    }
}
