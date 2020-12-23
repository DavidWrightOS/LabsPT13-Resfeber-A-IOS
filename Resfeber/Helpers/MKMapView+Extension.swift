//
//  MKMapView+Extension.swift
//  Resfeber
//
//  Created by David Wright on 12/14/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import MapKit

extension MKMapView {
    func zoomToFit(annotations: [MKAnnotation]? = nil, edgePadding: UIEdgeInsets? = nil) {
        let zoomRect = annotationsMapRect(annotations)
        let edgePadding = edgePadding ?? UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100)
        setVisibleMapRect(zoomRect, edgePadding: edgePadding, animated: true)
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
