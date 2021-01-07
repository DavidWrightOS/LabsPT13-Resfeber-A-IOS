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
        if let line1 = addressLine1 {
            if let line2 = addressLine2 {
                return line1 + ", " + line2
            }
            return line1
        }
        return addressLine2
    }
    
    var addressTwoLineFormat: String? {
        if let line1 = addressLine1 {
            if let line2 = addressLine2 {
                return line1 + "\n" + line2
            }
            return line1
        }
        return addressLine2
    }
    
    var addressLine1: String? {
        var line1 = subThoroughfare ?? ""
        if let thoroughfare = thoroughfare {
            line1 += line1.isEmpty ? thoroughfare : " " + thoroughfare
        }
        return line1.isEmpty ? nil : line1
    }
    
    var addressLine2: String? {
        var line2 = locality ?? ""
        if let administrativeArea = administrativeArea {
            line2 += line2.isEmpty ? administrativeArea : ", " + administrativeArea
            if let postalCode = postalCode {
                line2 += " " + postalCode
            }
        }
        return line2.isEmpty ? nil : line2
    }
}
