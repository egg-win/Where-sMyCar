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
        let themeConfigurator = ThemeConfigurator.shared
        tabBar.isTranslucent = themeConfigurator.tabBarStyle.isTranslucent
        tabBar.barTintColor = themeConfigurator.tabBarStyle.barTintColor
        tabBar.tintColor = themeConfigurator.tabBarStyle.tintColor
    }
}
