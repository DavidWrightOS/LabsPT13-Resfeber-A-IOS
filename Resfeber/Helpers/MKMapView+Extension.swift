//
//  MKMapView+Extension.swift
//  Resfeber
//
//  Created by David Wright on 12/14/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import MapKit

extension MKMapView {
    func zoomToFit(annotations: [MKAnnotation]? = nil, edgePadding: UIEdgeInsets? = nil, animated: Bool = true) {
        let annotations = annotations ?? self.annotations
        let zoomRect = annotationsMapRect(annotations)
        let edgePadding = edgePadding ?? UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
        if annotations.count > 1 {
            setVisibleMapRect(zoomRect, edgePadding: edgePadding, animated: animated)
        } else if let annotation = annotations.first {
            let location = CLLocation(latitude: annotation.coordinate.latitude,
                                      longitude: annotation.coordinate.longitude)
            centerToLocation(location, regionRadius: 300, animated: animated)
        }
    }
    
    func annotationsMapRect(_ annotations: [MKAnnotation]? = nil) -> MKMapRect {
        let annotations = annotations ?? self.annotations
        var regionRect = MKMapRect.null
        
        annotations.forEach { annotation in
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01)
            regionRect = regionRect.union(pointRect)
        }
        
        return regionRect
    }
}

private extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000, animated: Bool = true) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: animated)
    }
}
