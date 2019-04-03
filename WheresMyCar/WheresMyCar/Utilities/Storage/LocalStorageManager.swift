//
//  LocalStorageManager.swift
//  WheresMyCar
//
//  Created by AllenLai on 2019/4/2.
//  Copyright © 2019 EggWin. All rights reserved.
//

import Foundation

class LocalStorageManager {
    // MARK: - Properties
    static let shared = LocalStorageManager()
    private let userDefaults = UserDefaults.standard
    
    private enum UserDefaultsKey: String {
        case latitude
        case longitude
    }
    
    // MARK: - Public method
    func location() -> (latitude: Double?, longitude: Double?) {
        guard let latitude = latitude(), let longitude = longitude() else { return (nil, nil) }
        return (latitude, longitude)
    }
    
    func removeLocation() {
        remove(forKey: .latitude)
        remove(forKey: .longitude)
    }
    
    func latitude() -> Double? {
        return double(forKey: .latitude)
    }
    
    func setLatitude(_ latitude: Double) {
        set(latitude, forKey: .latitude)
    }
    
    func longitude() -> Double? {
        return double(forKey: .longitude)
    }
    
    func setLongitude(_ longitude: Double) {
        set(longitude, forKey: .longitude)
    }
    
    // MARK: - Private method
    private func string(forKey key: UserDefaultsKey) -> String? {
        guard let stringValue = userDefaults.string(forKey: key.rawValue) else { return nil }
        return stringValue
    }
    
    private func double(forKey key: UserDefaultsKey) -> Double? {
        return userDefaults.double(forKey: key.rawValue)
    }
    
    private func set(_ value: Any, forKey key: UserDefaultsKey) {
        userDefaults.set(value, forKey: key.rawValue)
    }
    
    private func remove(forKey key: UserDefaultsKey) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
}
