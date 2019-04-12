//
//  LocalDataProvider.swift
//  WheresMyCar
//
//  Created by AllenLai on 2019/4/12.
//  Copyright © 2019 EggWin. All rights reserved.
//

import Foundation

class LocalDataProvider {
    // MARK: - Properties
    static let shared = LocalDataProvider()
    private let localDatabaseManager = LocalDatabaseManager.shared
    private let localStorageManager = LocalStorageManager.shared
    
    // Database
    func queryAllUser() -> [UserModel] {
        var users = [UserModel]()
        guard let result = localDatabaseManager.queryData(from: UserModel.tableName) else { return users }
        
        while result.next() {
            let user = UserModel(name: result.string(forColumn: "name") ?? "",
                                 height: result.double(forColumn: "height"),
                                 age: Int(result.int(forColumn: "age")))
            users.append(user)
        }
        return users
    }
    
    func queryUser(withHeight height: Int) -> [UserModel] {
        var users = [UserModel]()
        guard let result = localDatabaseManager.queryData(from: UserModel.tableName,
                                     columns: [],
                                     conditionColumnValues: [DatabaseConditionColumnValue(column: "height", operatorType: .greaterThan, value: height)],
                                     orderBy: "name",
                                     ascending: .ascending) else { return users }
        
        while result.next() {
            let user = UserModel(name: result.string(forColumn: "name") ?? "",
                                 height: result.double(forColumn: "height"),
                                 age: Int(result.int(forColumn: "age")))
            users.append(user)
        }
        return users
    }
    
    // UserDefaults
    func location() -> (latitude: Double?, longitude: Double?) {
        guard let latitude = latitude(), let longitude = longitude() else { return (nil, nil) }
        return (latitude, longitude)
    }
    
    func latitude() -> Double? {
        return localStorageManager.double(forKey: .latitude)
    }
    
    func longitude() -> Double? {
        return localStorageManager.double(forKey: .longitude)
    }
}
