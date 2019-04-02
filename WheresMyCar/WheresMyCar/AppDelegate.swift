//
//  AppDelegate.swift
//  WheresMyCar
//
//  Created by Allen Lai on 2019/2/17.
//  Copyright © 2019 EggWin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - Properties
    var window: UIWindow?
    
    lazy var logTextView: LogTextView = {
        let logTextView = LogTextView(frame: .zero)
        logTextView.layer.zPosition = .greatestFiniteMagnitude
        return logTextView
    }()

    // MARK: - App lifecycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupWindow()
        setupConfigure()
        setupLogTextView()
        printLog("application(_:, didFinishLaunchingWithOptions:)")
        
        return true
    }
    
    // MARK: - Private method
    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else { fatalError() }
        window.rootViewController = LaunchViewController()
        window.makeKeyAndVisible()
    }
    
    private func setupConfigure() {
        LogLevelConfigurator.shared.configure([.log, .error, .warn, .debug, .info, .verbose], shouldShow: true, shouldCache: true)
        ThemeConfigurator.shared.configure(navigationBarStyle: NavigationBarStyle(isPrefersLargeTitles: true,
                                                                                  isTranslucent: false,
                                                                                  barTintColor: .appleBlue,
                                                                                  tintColor: .white,
                                                                                  titleTextForegroundColor: .white),
                                           tabBarStyle: TabBarStyle(isTranslucent: false,
                                                                    barTintColor: .appleBlue,
                                                                    tintColor: .white))
    }
    
    private func setupLogTextView() {
//        #if DEBUG

        guard let window = window else { return }
        
        if #available(iOS 11.0, *) {
            window.addSubview(logTextView, constraints: [
                UIView.constraintEqual(from: \UIView.topAnchor, to: \UIView.safeAreaLayoutGuide.topAnchor, constant: .defaultMargin),
                UIView.constraintEqual(from: \UIView.leadingAnchor, to: \UIView.safeAreaLayoutGuide.leadingAnchor, constant: .defaultMargin),
                UIView.constraintEqual(from: \UIView.bottomAnchor, to: \UIView.safeAreaLayoutGuide.bottomAnchor, constant: .defaultMargin),
                UIView.constraintEqual(from: \UIView.trailingAnchor, to: \UIView.safeAreaLayoutGuide.trailingAnchor, constant: .defaultMargin)
                ])
        } else {
            window.addSubview(logTextView, constraints: [
                UIView.constraintEqual(from: \UIView.topAnchor, to: \UIView.topAnchor, constant: .defaultMargin),
                UIView.constraintEqual(from: \UIView.leadingAnchor, to: \UIView.leadingAnchor, constant: .defaultMargin),
                UIView.constraintEqual(from: \UIView.bottomAnchor, to: \UIView.bottomAnchor, constant: .defaultMargin),
                UIView.constraintEqual(from: \UIView.trailingAnchor, to: \UIView.trailingAnchor, constant: .defaultMargin)
            ])
        }
        
//        #endif
    }
}
