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
        let themeConfigurator = ThemeConfigurator.shared
        
        navigationBar.isTranslucent = themeConfigurator.navigationBarStyle.isTranslucent
        navigationBar.barTintColor = themeConfigurator.navigationBarStyle.barTintColor
        navigationBar.tintColor = themeConfigurator.navigationBarStyle.tintColor
        
        if #available(iOS 11.0, *) {
            navigationBar.prefersLargeTitles = themeConfigurator.navigationBarStyle.isPrefersLargeTitles
            if let navigationBarTitleTextForegroundColor = themeConfigurator.navigationBarStyle.titleTextForegroundColor {
                navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: navigationBarTitleTextForegroundColor]
            }
        } else {
            if let navigationBarTitleTextForegroundColor = themeConfigurator.navigationBarStyle.titleTextForegroundColor {
                navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: navigationBarTitleTextForegroundColor]
            }
        }
    }
}
