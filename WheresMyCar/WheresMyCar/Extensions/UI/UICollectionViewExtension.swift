//
//  UICollectionViewExtension.swift
//  WheresMyCar
//
//  Created by AllenLai on 2019/4/2.
//  Copyright © 2019 EggWin. All rights reserved.
//

import UIKit

extension UICollectionView {
    func register(cellClasses: UICollectionViewCell.Type...) {
        cellClasses.forEach { self.register($0, forCellWithReuseIdentifier: $0.className) }
    }
}
