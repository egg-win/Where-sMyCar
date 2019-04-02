//
//  LogLevelConfigurator.swift
//  WheresMyCar
//
//  Created by AllenLai on 2019/4/2.
//  Copyright © 2019 EggWin. All rights reserved.
//

import Foundation

enum LogLevel: String {
    case log, error, warn, debug, info, verbose
}

class LogLevelConfigurator {
    // MARK: - Properties
    static let shared = LogLevelConfigurator()
    private(set) var logLevels = [LogLevel]()
    private(set) var shouldShow = false
    private(set) var shouldCache = false
    
    // MARK: - Initializer
    private init() {  }
    
    // MARK: - Public method
    func configure(_ logLevels: [LogLevel], shouldShow: Bool = false, shouldCache: Bool = false) {
        self.logLevels = logLevels
        self.shouldShow = shouldShow
        self.shouldCache = shouldCache
    }
}
