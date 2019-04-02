//
//  LocalStorageManager.swift
//  WheresMyCar
//
//  Created by AllenLai on 2019/4/2.
//  Copyright © 2019 EggWin. All rights reserved.
//

import Foundation

class LocalStorageManager {
    static let shared = LocalStorageManager()
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Public method
    func stringValue() -> String? {
        return string(forKey: "string")
    }
    
    func setStringValue(_ stringValue: String) {
        userDefaults.set(stringValue, forKey: stringValue)
    }
    
    // MARK: - Private method
    private func string(forKey key: String) -> String? {
        guard let stringValue = userDefaults.string(forKey: key) else { return nil }
        return stringValue
    }
}
