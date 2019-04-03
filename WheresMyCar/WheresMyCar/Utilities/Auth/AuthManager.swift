//
//  AuthManager.swift
//  WheresMyCar
//
//  Created by AllenLai on 2019/4/3.
//  Copyright © 2019 EggWin. All rights reserved.
//

import Foundation
import CoreLocation

enum AuthType {
    case map
    case location
}

struct AuthManager {
    typealias LocationAuthStatusCallback = (CLAuthorizationStatus) -> Void
    
    static func setupAuth(with authType: AuthType, notDetermined: LocationAuthStatusCallback, success: LocationAuthStatusCallback, failure: LocationAuthStatusCallback) {
        switch authType {
        case .map: break
        case .location:
            setupLocationAuth(notDetermined: notDetermined, success: success, failure: failure)
        }
    }
    
    private static func setupLocationAuth(notDetermined: LocationAuthStatusCallback, success: LocationAuthStatusCallback, failure: LocationAuthStatusCallback) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways: success(.authorizedAlways)
        case .authorizedWhenInUse: success(.authorizedWhenInUse)
        case .denied: failure(.denied)
        case .notDetermined: notDetermined(.notDetermined)
        case .restricted: failure(.restricted)
        }
    }
}
