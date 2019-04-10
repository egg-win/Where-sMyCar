//
//  DictionaryExtension.swift
//  WheresMyCar
//
//  Created by AllenLai on 2019/4/8.
//  Copyright © 2019 EggWin. All rights reserved.
//

import Foundation

extension Dictionary {
    /// 可以在預設設定(default dictionary)增加新的patch dictionay作為新的設定
    ///
    /// - Parameter sequence: Another dictionary.
    mutating func merge<S: Sequence>(_ sequence: S) where S.Iterator.Element == (key: Key, value: Value) {
        sequence.forEach { self[$0] = $1 }
    }
    
    /// 預設設定空dictionay增加新的dictionay
    ///
    /// - Parameter sequence: a dictionary.
    init<S: Sequence>(_ sequence: S) where S.Iterator.Element == (key: Key, value: Value) {
        self = [:]
        self.merge(sequence)
    }
}
