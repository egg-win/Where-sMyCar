//
//  DeviceInfo.swift
//  WheresMyCar
//
//  Created by AllenLai on 2019/4/2.
//  Copyright © 2019 EggWin. All rights reserved.
//

import UIKit

struct DeviceInfo {
    static var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    static var navigationBarHeight: CGFloat {
        guard let keyWindow = UIApplication.shared.keyWindow else { return 0.0 }
        return keyWindow.rootViewController?.navigationController?.navigationBar.frame.size.height ?? 0.0
    }
    
    static var tabBarHeight: CGFloat {
        guard let keyWindow = UIApplication.shared.keyWindow else { return 0.0 }
        return keyWindow.rootViewController?.tabBarController?.tabBar.frame.size.height ?? 0.0
    }
}
