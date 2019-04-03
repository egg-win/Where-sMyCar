//
//  ThemeConfigurator.swift
//  WheresMyCar
//
//  Created by AllenLai on 2019/4/2.
//  Copyright © 2019 EggWin. All rights reserved.
//

import UIKit

struct NavigationBarStyle {
    var isPrefersLargeTitles = false
    var isTranslucent = true
    var barTintColor: UIColor?
    var tintColor: UIColor?
    var titleTextForegroundColor: UIColor?
}

struct TabBarStyle {
    var isTranslucent = true
    var barTintColor: UIColor?
    var tintColor: UIColor?
}

class ThemeConfigurator {
    // MARK: - Properties
    static let shared = ThemeConfigurator()
    private(set) var navigationBarStyle = NavigationBarStyle()
    private(set) var tabBarStyle = TabBarStyle()
    
    // MARK: - Initializer
    private init() {  }
    
    // MARK: - Public method
    func configure(navigationBarStyle: NavigationBarStyle, tabBarStyle: TabBarStyle) {
        configure(isPrefersLargeTitles: navigationBarStyle.isPrefersLargeTitles,
                  isTranslucent: navigationBarStyle.isTranslucent,
                  barTintColor: navigationBarStyle.barTintColor,
                  tintColor: navigationBarStyle.tintColor,
                  titleTextForegroundColor: navigationBarStyle.titleTextForegroundColor)
        configure(isTranslucent: tabBarStyle.isTranslucent,
                  barTintColor: tabBarStyle.barTintColor,
                  tintColor: tabBarStyle.tintColor)
    }
    
    func configure(isPrefersLargeTitles: Bool = false,
                   isTranslucent: Bool = true,
                   barTintColor: UIColor?,
                   tintColor: UIColor?,
                   titleTextForegroundColor: UIColor?) {
        navigationBarStyle.isTranslucent = isTranslucent
        navigationBarStyle.isPrefersLargeTitles = isPrefersLargeTitles
        
        if let barTintColor = barTintColor {
            navigationBarStyle.barTintColor = barTintColor
        }
        
        if let tintColor = tintColor {
            navigationBarStyle.tintColor = tintColor
        }
        
        if let titleTextForegroundColor = titleTextForegroundColor {
            navigationBarStyle.titleTextForegroundColor = titleTextForegroundColor
        }
    }
    
    func configure(isTranslucent: Bool = true,
                   barTintColor: UIColor?,
                   tintColor: UIColor?) {
        tabBarStyle.isTranslucent = isTranslucent
        
        if let barTintColor = barTintColor {
            tabBarStyle.barTintColor = barTintColor
        }
        
        if let tintColor = tintColor {
            tabBarStyle.tintColor = tintColor
        }
    }
}
