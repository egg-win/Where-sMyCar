//
//  UIAlertControllerExtension.swift
//  WheresMyCar
//
//  Created by AllenLai on 2019/4/2.
//  Copyright © 2019 EggWin. All rights reserved.
//

import UIKit

struct ActionInfo {
    var title: String?
    var style: UIAlertAction.Style
    var handler: ((UIAlertAction) -> Void)?
}

extension UIAlertController {
    static func alert(title: String?, message: String?, preferredStyle: UIAlertController.Style = .alert, actions: ActionInfo...) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        actions.forEach { alertController.addAction(UIAlertAction(title: $0.title, style: $0.style, handler: $0.handler)) }
        
        if let topViewController = UIApplication.topViewController() {
            DispatchQueue.main.async {
                topViewController.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    static func remindAlert(title: String?, message: String?, preferredStyle: UIAlertController.Style = .alert) {
        UIAlertController.alert(title: title, message: message, actions: ActionInfo(title: "OK", style: .default, handler: nil))
    }
}
