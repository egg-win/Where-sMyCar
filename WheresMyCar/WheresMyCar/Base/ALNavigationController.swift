//
//  ALNavigationController.swift
//  WheresMyCar
//
//  Created by AllenLai on 2019/4/2.
//  Copyright © 2019 EggWin. All rights reserved.
//

import UIKit

class ALNavigationController: UINavigationController {
    // MARK: - NavigationController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: - Private method
    private func setupUI() {
        navigationBar.isTranslucent = false
        let themeConfigurator = ThemeConfigurator.shared
        navigationBar.barTintColor = themeConfigurator.navigationBarBarTintColor
        navigationBar.tintColor = themeConfigurator.navigationBarTintColor
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: themeConfigurator.navigationBarTitleTextForegroundColor]
    }
}
