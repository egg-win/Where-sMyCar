//
//  ArrayExtension.swift
//  WheresMyCar
//
//  Created by AllenLai on 2019/4/8.
//  Copyright © 2019 EggWin. All rights reserved.
//

import Foundation

extension Array {
    func reject(_ predicate: (Element) -> Bool) -> [Element] {
        return filter { !predicate($0) }
    }
    
    func allMatch(_ predicate: (Element) -> Bool) -> Bool {
        return !contains { !predicate($0) }
    }
}
