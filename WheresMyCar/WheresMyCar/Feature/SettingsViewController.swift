//
//  SettingsViewController.swift
//  WheresMyCar
//
//  Created by AllenLai on 2019/4/2.
//  Copyright © 2019 EggWin. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // FIXME: - database demo code
        let localDatabaseManager = LocalDatabaseManager.shared
        localDatabaseManager.create(table: .demoTable, columns: [
            DatabaseColumn(name: "name", dataType: .text),
            DatabaseColumn(name: "height", dataType: .real),
            DatabaseColumn(name: "age", dataType: .integer)], identifierMode: .serial)

        localDatabaseManager.create(table: .demoTable2, columns: [
            DatabaseColumn(name: "name2", dataType: .text),
            DatabaseColumn(name: "height2", dataType: .real),
            DatabaseColumn(name: "age2", dataType: .integer)], identifierMode: .unique)
        
        localDatabaseManager.create(table: .demoTable3, columns: [
            DatabaseColumn(name: "id", dataType: .text, canNull: false, isPrimaryKey: true, defaultValue: nil),
            DatabaseColumn(name: "name3", dataType: .text, canNull: true, isPrimaryKey: false),
            DatabaseColumn(name: "height3", dataType: .real, canNull: true, isPrimaryKey: false),
            DatabaseColumn(name: "age3", dataType: .integer, canNull: true, isPrimaryKey: false)
            ], identifierMode: .none)
        
        for i in 10...50 {
            localDatabaseManager.insertData(into: .demoTable, columnValues: ["name": "Allen\(i)",
                                                                             "height": Double.random(in: 100.0..<190.0),
                                                                             "age": i], identifierMode: .serial)
        }
        
        localDatabaseManager.insertData(into: .demoTable, columnValues: ["name": "John",
                                                                         "height": 184.5,
                                                                         "age": 31], identifierMode: .serial)
        localDatabaseManager.insertData(into: .demoTable2, columnValues: ["name2": "Allen",
                                                                          "height2": 184.5,
                                                                          "age2": 31], identifierMode: .unique)
        localDatabaseManager.insertData(into: .demoTable3, columnValues: ["id": UUID().uuidString,
                                                                          "name3": "Allen3",
                                                                          "height3": 184.5,
                                                                          "age3": 31], identifierMode: .none)
        
        localDatabaseManager.updateData(at: .demoTable, columnValues: ["height": 10.0],
                                        conditionColumnValues: [DatabaseConditionColumnValue(column: "name", operatorType: .equalTo, value: "Allen20")])
        
        let localDataProvider = LocalDataProvider.shared
        let user1 = localDataProvider.queryAllUser()
        printLog("user1 -> \(user1)", level: .log)
        let user2 = localDataProvider.queryUser(withHeight: 120)
        printLog("user2 -> \(user2)", level: .log)
        
        localDatabaseManager.deleteData(from: .demoTable, conditionColumnValues: [DatabaseConditionColumnValue(column: "name", operatorType: .equalTo, value: "John")])
    }
}
