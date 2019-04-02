//
//  StringExtension.swift
//  WheresMyCar
//
//  Created by AllenLai on 2019/4/2.
//  Copyright © 2019 EggWin. All rights reserved.
//

import Foundation

extension String {
    func saveLog() throws {
        guard let cachesDirectory = FileManager.cachesDirectory else { return }
        let filePath = cachesDirectory.appendingPathComponent("\(Date.currentDateString(from: .yyyyMMdd)).log")
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath.path) {  // adding content to file
            let fileHandle = FileHandle(forWritingAtPath: filePath.path)
            let content = "\(self)\n"
            fileHandle?.seekToEndOfFile()
            fileHandle?.write(content.data(using: .utf8) ?? Data())
        } else {                                            // create new file
            do {
                try self.write(to: filePath, atomically: false, encoding: .utf8)
            } catch {
                throw error
            }
        }
    }
    
    func convertToDate(from dateFormat: DateFormat) -> Date? {
        let dateFormatter = DateFormatter.shared
        dateFormatter.dateFormat = dateFormat.rawValue
        return dateFormatter.date(from: self)
    }
}
