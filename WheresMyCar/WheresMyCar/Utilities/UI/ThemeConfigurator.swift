//
//  ThemeConfigurator.swift
//  WheresMyCar
//
//  Created by AllenLai on 2019/4/2.
//  Copyright © 2019 EggWin. All rights reserved.
//

import UIKit

class ThemeConfigurator {
    // MARK: - Properties
    static let shared = ThemeConfigurator()
    private(set) var navigationBarBarTintColor: UIColor?
    private(set) var navigationBarTintColor: UIColor?
    private(set) var navigationBarTitleTextForegroundColor: UIColor!
    private(set) var tabBarBarTintColor: UIColor?
    private(set) var tabBarTintColor: UIColor?
    
    // MARK: - Initializer
    private init() {  }
    
    func configure(navigationBarBarTintColor: UIColor, navigationBarTintColor: UIColor, navigationBarTitleTextForegroundColor: UIColor, tabBarBarTintColor: UIColor, tabBarTintColor: UIColor) {
        configure(navigationBarBarTintColor: navigationBarBarTintColor, navigationBarTintColor: navigationBarTintColor, navigationBarTitleTextForegroundColor: navigationBarTitleTextForegroundColor)
        configure(tabBarBarTintColor: tabBarBarTintColor, tabBarTintColor: tabBarTintColor)
    }
    
    func configure(navigationBarBarTintColor: UIColor, navigationBarTintColor: UIColor, navigationBarTitleTextForegroundColor: UIColor) {
        self.navigationBarBarTintColor = navigationBarBarTintColor
        self.navigationBarTintColor = navigationBarTintColor
        self.navigationBarTitleTextForegroundColor = navigationBarTitleTextForegroundColor
    }
    
    func configure(tabBarBarTintColor: UIColor, tabBarTintColor: UIColor) {
        self.tabBarBarTintColor = tabBarBarTintColor
        self.tabBarTintColor = tabBarTintColor
    }
}
