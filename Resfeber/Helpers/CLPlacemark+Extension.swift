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
        var addressString = ""
        
        if let subThoroughfare = subThoroughfare {
            addressString += subThoroughfare
        }
        
        if let thoroughfare = thoroughfare {
            addressString += addressString.isEmpty ? thoroughfare : " " + thoroughfare
        }
        
        if let locality = locality {
            addressString += addressString.isEmpty ? locality : ", " + locality
        }
        
        if let administrativeArea = administrativeArea {
            addressString += addressString.isEmpty ? administrativeArea : ", " + administrativeArea
            
            if let postalCode = postalCode {
                addressString += " " + postalCode
            }
        }
        
        return addressString.isEmpty ? nil : addressString
    }
}
