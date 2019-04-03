//
//  CLGeocoderExtension.swift
//  WheresMyCar
//
//  Created by AllenLai on 2019/4/3.
//  Copyright © 2019 EggWin. All rights reserved.
//

import Foundation
import CoreLocation

extension CLGeocoder {
    func addressLocation(from location: CLLocation, placemarkCompletionHandler: @escaping (CLPlacemark) -> Void) {
        reverseGeocodeLocation(location) { (placemarks, _) in
            guard let placemark = placemarks?.first else { return }
            placemarkCompletionHandler(placemark)
        }
    }
}
