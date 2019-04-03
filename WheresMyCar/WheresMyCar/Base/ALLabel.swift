//
//  ALLabel.swift
//  WheresMyCar
//
//  Created by AllenLai on 2019/4/3.
//  Copyright © 2019 EggWin. All rights reserved.
//

import UIKit

class ALLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: .defaultMargin / 2, left: .defaultMargin, bottom: .defaultMargin, right: .defaultMargin / 2)
        super.drawText(in: rect.inset(by: insets))
    }
}
