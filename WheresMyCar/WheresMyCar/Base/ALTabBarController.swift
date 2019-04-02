//
//  ALTabBarController.swift
//  WheresMyCar
//
//  Created by AllenLai on 2019/4/2.
//  Copyright © 2019 EggWin. All rights reserved.
//

import UIKit

class ALTabBarController: UITabBarController {
    // MARK: - TabBarController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: - Private method
    private func setupUI() {
        tabBar.isTranslucent = false
        let themeConfigurator = ThemeConfigurator.shared
        tabBar.barTintColor = themeConfigurator.tabBarBarTintColor
        tabBar.tintColor = themeConfigurator.tabBarTintColor
    }
}
