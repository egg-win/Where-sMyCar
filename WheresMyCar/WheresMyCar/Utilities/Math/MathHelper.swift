//
//  MathHelper.swift
//  WheresMyCar
//
//  Created by AllenLai on 2019/4/2.
//  Copyright © 2019 EggWin. All rights reserved.
//

import Foundation

struct MathHelper {
    static func round<T>(with value: T, scale: Int) -> T? {
        guard let doubleValue = value as? Double else { return nil }
        var decimalValue = Decimal(doubleValue)
        var decimal = Decimal()
        NSDecimalRound(&decimal, &decimalValue, scale, .plain)
        return NSDecimalNumber(decimal: decimal).doubleValue as? T
    }
}
