//
//  TimeCalculator.swift
//  WheresMyCar
//
//  Created by AllenLai on 2019/4/2.
//  Copyright © 2019 EggWin. All rights reserved.
//

import UIKit

class TimeCalculator {
    static func check(designatedTimeInterval: CFTimeInterval, isOver secondThreshold: CFTimeInterval) -> Bool {
        let currentTimeInterval = CACurrentMediaTime()
        if currentTimeInterval - designatedTimeInterval >= secondThreshold {
            return true
        }
        return false
    }
}
