//
//  LocalDatabaseManager.swift
//  WheresMyCar
//
//  Created by AllenLai on 2019/4/11.
//  Copyright © 2019 EggWin. All rights reserved.
//

import Foundation
import FMDB

enum DBTable: String {
    case demoTable = "demo_table"
    case demoTable2 = "demo_table2"
    case demoTable3 = "demo_table3"
}

enum DBIdentifierMode {
    case none
    case serial // 流水號
    case unique // uuid
}

enum DBDataType: String {
    case null = "NULL"
    case integer = "INTEGER"
    case real = "REAL"
    case text = "TEXT"
    case blob = "BLOB"
}

struct DatabaseColumn {
    var name: String
    var dataType: DBDataType
    var canNull: Bool
    var isPrimaryKey: Bool
    var defaultValue: Any?
    
    init(name: String, dataType: DBDataType, canNull: Bool = true, isPrimaryKey: Bool = false, defaultValue: Any? = nil) {
        self.name = name
        self.dataType = dataType
        self.canNull = canNull
        self.isPrimaryKey = isPrimaryKey
        self.defaultValue = defaultValue
    }
}

enum DBConditionType: String {
    case none
    case and = "AND"
    case or = "OR"
}

enum DBOrderType: String {
    case none
    case ascending = "ASC"
    case descending = "DESC"
}

enum DBOperatorType: String {
    case equalTo = "="
    case greaterThan = ">"
    case lessThan = "<"
    case greaterThanOrEqualTo = ">="
    case lessThanOrEqualTo = "<="
    case notEqualTo = "<>"
}

struct DatabaseConditionColumnValue {
    var condition: DBConditionType
    var column: String
    var operatorType: DBOperatorType
    var value: Any
    
    init(condition: DBConditionType = .none, column: String, operatorType: DBOperatorType, value: Any) {
        self.condition = condition
        self.column = column
        self.operatorType = operatorType
        self.value = value
    }
}

class LocalDatabaseManager: NSObject {
    // MARK: - Properties
    static let shared = LocalDatabaseManager()
    var fileName = "data.sqlite"
    var filePath: URL!
    var database: FMDatabase!
    
    // MARK: - Initializer
    private override init() {
        super.init()
        
        guard let filePath = FileManager.documentDirectory?.appendingPathComponent(fileName) else { return }
        self.filePath = filePath
        
        printLog("Database file path: \(filePath.path)", level: .log)
    }
    
    deinit {
        printLog("Database deinit: \(self)", level: .log)
    }
    
    // MARK: - Public method
    func create(table: DBTable, columns: [DatabaseColumn], identifierMode: DBIdentifierMode = .unique) {
        func createColumnDefaultValueString(from defaultValue: Any?) -> String {
            guard let defaultValue = defaultValue else { return "" }
            switch defaultValue {
            case let value where value is Int || value is Double: return " DEFAULT \(value)"
            case let value where value is String: return " DEFAULT '\(value)'"
            default: return ""
            }
        }
        
        func createColumnsStatement(columns: [DatabaseColumn], identifierMode: DBIdentifierMode) -> String {
            switch identifierMode {
            case .none:
                return String(columns.reduce("") {
                    let defalutValueString = createColumnDefaultValueString(from: $1.defaultValue)
                    return $0 + "\($1.name) \($1.dataType.rawValue)\($1.canNull ? " " : " NOT NULL")\($1.isPrimaryKey ? " PRIMARY KEY" : " ")\(defalutValueString), "
                    }.dropLast(2))
            case .serial:
                return String(columns.reduce("id INTEGER NOT NULL PRIMARY KEY, create_date TEXT NOT NULL, update_date TEXT NOT NULL, ") {
                    let defalutValueString = createColumnDefaultValueString(from: $1.defaultValue)
                    return $0 + "\($1.name) \($1.dataType.rawValue)\($1.canNull ? " " : " NOT NULL")\($1.isPrimaryKey ? " PRIMARY KEY" : " ")\(defalutValueString), "
                    }.dropLast(2))
            case .unique:
                return String(columns.reduce("id TEXT NOT NULL PRIMARY KEY, create_date TEXT NOT NULL, update_date TEXT NOT NULL, ") {
                    let defalutValueString = createColumnDefaultValueString(from: $1.defaultValue)
                    return $0 + "\($1.name) \($1.dataType.rawValue)\($1.canNull ? " " : " NOT NULL")\($1.isPrimaryKey ? " PRIMARY KEY" : " ")\(defalutValueString), "
                    }.dropLast(2))
            }
        }
        
        if open() {
            let columnsStatement = createColumnsStatement(columns: columns, identifierMode: identifierMode)
            let createTableSQL = "CREATE TABLE \(table.rawValue) (\(columnsStatement))"
            printLog("Create table SQL: \(createTableSQL)", level: .log)
            
            database.executeStatements(createTableSQL)
            printLog("Create table success", level: .log)
        } else {
            printLog("Open table failure", level: .error)
        }
    }
    
    func open() -> Bool {
        database = FMDatabase(url: filePath)
        if database != nil {
            return database.open() ? true : false
        }
        return false
    }
    
    // Create
    func insertData(into table: DBTable, columnValues: [String: Any], identifierMode: DBIdentifierMode = .unique) {
        func insertDataColumnsStatement(from table: DBTable, columnValues: [String: Any], identifierMode: DBIdentifierMode) -> (columnsSQL: String, valuesSQL: String) {
            switch identifierMode {
            case .none:
                let columnsSQL = String(columnValues.map { $0.key }.reduce("") { $0 + "\($1), " }.dropLast(2))
                let valuesSQL = String(columnValues.map { $0.value }.reduce("") { result, _ in result + "?, " }.dropLast(2))
                return (columnsSQL, valuesSQL)
            case .serial:
                let columnsSQL = String(columnValues.map { $0.key }.reduce("id, create_date, update_date, ") { $0 + "\($1), " }.dropLast(2))
                let valuesSQL = String(columnValues.map { $0.value }.reduce("(SELECT IFNULL(MAX(ID), 0) + 1 FROM \(table.rawValue)), '\(Date.currentDateString())', '\(Date.currentDateString())', ") { result, _ in
                    result + "?, " }
                    .dropLast(2))
                return (columnsSQL, valuesSQL)
            case .unique:
                let columnsSQL = String(columnValues.map { $0.key }.reduce("id, create_date, update_date, ") { $0 + "\($1), " }.dropLast(2))
                let valuesSQL = String(columnValues.map { $0.value }.reduce("'\(UUID().uuidString)', '\(Date.currentDateString())', '\(Date.currentDateString())', ") { result, _ in result + "?, " }.dropLast(2))
                return (columnsSQL, valuesSQL)
            }
        }
        
        guard open() else { return }
        
        let columnsStatement = insertDataColumnsStatement(from: table, columnValues: columnValues, identifierMode: identifierMode)
        
        let insertSQL = "INSERT INTO \(table.rawValue) (\(columnsStatement.columnsSQL)) VALUES (\(columnsStatement.valuesSQL))"
        printLog("InsertSQL: \(insertSQL)", level: .log)
        
        if database.executeUpdate(insertSQL, withArgumentsIn: columnValues.map { $0.value }) == false {
            printLog("Insert data fail", level: .error)
            printLog("\(database.lastError()), \(database.lastErrorMessage())", level: .error)
        }
        
        database.close()
    }
    
    // Read
    func queryData(from table: DBTable, columns: [String] = [], conditionColumnValues: [DatabaseConditionColumnValue] = [], orderBy orderColumn: String = "", ascending: DBOrderType = .none) -> FMResultSet? {
        func queryDataColumnsStatement(columns: [String]) -> String {
            if columns.count == 0 {
                return "*"
            } else {
                return String(columns.reduce("") { $0 + "\($1), " }.dropLast(2))
            }
        }
        
        func queryDataConditionStatement(conditionColumnValues: [DatabaseConditionColumnValue]) -> String {
            var conditionColumns = ""
            if let firstConditionColumnValue = conditionColumnValues.first {
                conditionColumns = "WHERE \(firstConditionColumnValue.column) \(firstConditionColumnValue.operatorType.rawValue) ?"
                for i in 1..<conditionColumnValues.count {
                    conditionColumns += "\(conditionColumnValues[i].condition) \(conditionColumnValues[i].column) \(conditionColumnValues[i].operatorType.rawValue) ?"
                }
            }
            
            return conditionColumns
        }
        
        func queryDataOrderStatement(orderBy orderColumn: String, ascending: DBOrderType) -> String {
            if orderColumn != "", ascending != .none {
                return "ORDER BY \(orderColumn) \(ascending.rawValue)"
            }
            return ""
        }
        
        guard open() else { return nil }
        
        let columnsStatements = queryDataColumnsStatement(columns: columns)
        let conditionStatement = queryDataConditionStatement(conditionColumnValues: conditionColumnValues)
        let orderStatement = queryDataOrderStatement(orderBy: orderColumn, ascending: ascending)
        
        let querySQL = "SELECT \(columnsStatements) FROM \(table.rawValue) \(conditionStatement) \(orderStatement)"
        printLog("querySQL: \(querySQL)", level: .log)
        
        do {
            let resultSet = try database.executeQuery(querySQL, values: conditionColumnValues.map { $0.value })
            
            return resultSet
        } catch {
            printLog(error.localizedDescription, level: .error)
        }
        
        database.close()
        return nil
    }
    
    // Update
    func updateData(at table: DBTable, columnValues: [String: Any], conditionColumnValues: [DatabaseConditionColumnValue]) {
        func updateDataStatement(columns: [String], conditionColumnValues: [DatabaseConditionColumnValue]) -> String {
            let updateColumns = columns.reduce("update_date = ?, ") { $0 + "\($1) = ?, " }.dropLast(2)
            var conditionColumns = ""
            if let firstConditionColumnValue = conditionColumnValues.first {
                conditionColumns = "WHERE \(firstConditionColumnValue.column) \(firstConditionColumnValue.operatorType.rawValue) ?"
                for i in 1..<conditionColumnValues.count {
                    conditionColumns += "\(conditionColumnValues[i].condition) \(conditionColumnValues[i].column) \(conditionColumnValues[i].operatorType.rawValue) ?"
                }
            }
            
            return "\(updateColumns) \(conditionColumns)"
        }
        
        guard open() else { return }
        
        let statement = updateDataStatement(columns: columnValues.map { $0.key }, conditionColumnValues: conditionColumnValues)
        
        let updateSQL = "UPDATE \(table.rawValue) SET \(statement)"
        printLog("updateSQL: \(updateSQL)", level: .log)
        
        let values = columnValues.map { $1 }
        let conditionValues = conditionColumnValues.map { $0.value }
        let combineValues = [Date.currentDateString()] + values + conditionValues
        printLog("combineValues: \(combineValues)", level: .log)
        
        do {
            try database.executeUpdate(updateSQL, values: combineValues)
        } catch {
            printLog(error.localizedDescription, level: .error)
        }
        
        database.close()
    }
    
    // Delete
    func deleteData(from table: DBTable, conditionColumnValues: [DatabaseConditionColumnValue]) {
        func deleteDataConditionStatement(conditionColumnValues: [DatabaseConditionColumnValue]) -> String {
            var conditionColumns = ""
            if let firstConditionColumnValue = conditionColumnValues.first {
                conditionColumns = "WHERE \(firstConditionColumnValue.column) \(firstConditionColumnValue.operatorType.rawValue) ?"
                for i in 1..<conditionColumnValues.count {
                    conditionColumns += "\(conditionColumnValues[i].condition) \(conditionColumnValues[i].column) \(conditionColumnValues[i].operatorType.rawValue) ?"
                }
            }
            
            return conditionColumns
        }
        
        guard open() else { return }
        
        let conditionStatement = deleteDataConditionStatement(conditionColumnValues: conditionColumnValues)
        
        let deleteSQL = "DELETE FROM \(table.rawValue) \(conditionStatement)"
        printLog("deleteSQL: \(deleteSQL)", level: .log)
        
        do {
            try database.executeUpdate(deleteSQL, values: conditionColumnValues.map { $0.value })
        } catch {
            printLog(error.localizedDescription, level: .error)
        }
        
        database.close()
    }
}

// FIXME: - Fake model
protocol Storageable {
    static var tableName: DBTable { get set }
}

struct UserModel: Storageable {
    static var tableName: DBTable = .demoTable
    var name: String
    var height: Double
    var age: Int
}
