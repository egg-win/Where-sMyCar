//
//  SequenceExtension.swift
//  WheresMyCar
//
//  Created by AllenLai on 2019/4/9.
//  Copyright © 2019 EggWin. All rights reserved.
//

import Foundation

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var result: Set<Iterator.Element> = []
        return filter {
            if result.contains($0) {
                return false
            } else {
                result.insert($0)
                return true
            }
        }
    }
}
