//
//  MKMapViewExtension.swift
//  WheresMyCar
//
//  Created by AllenLai on 2019/4/3.
//  Copyright © 2019 EggWin. All rights reserved.
//

import Foundation
import MapKit

var didFocusMapRegion = false

extension MKMapView {
    func focusRegion(with center: CLLocationCoordinate2D, spanLatitudeDelta: CLLocationDegrees = 0.005, spanLongitudeDelta: CLLocationDegrees = 0.005) {
        if didFocusMapRegion == false {
            let span = MKCoordinateSpan(latitudeDelta: spanLatitudeDelta, longitudeDelta: spanLongitudeDelta)
            let region = MKCoordinateRegion(center: center, span: span)
            self.setRegion(region, animated: true)
            didFocusMapRegion = true
        }
    }
}
