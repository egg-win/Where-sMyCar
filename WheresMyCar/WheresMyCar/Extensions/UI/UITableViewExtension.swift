//
//  UITableViewExtension.swift
//  WheresMyCar
//
//  Created by AllenLai on 2019/4/2.
//  Copyright © 2019 EggWin. All rights reserved.
//

import UIKit

extension UITableView {
    func register(cellClasses: UITableViewCell.Type...) {
        cellClasses.forEach { self.register($0, forCellReuseIdentifier: $0.className) }
    }
}
