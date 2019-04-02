//
//  UIViewControllerExtension.swift
//  WheresMyCar
//
//  Created by AllenLai on 2019/4/2.
//  Copyright © 2019 EggWin. All rights reserved.
//

import UIKit

extension UIViewController {
    func addChild(_ childController: UIViewController, containerView: UIView, anchorHandler: @escaping (_ parentView: UIView, _ subView: UIView) -> Void) {
        addChild(childController)
        containerView.addSubview(childController.view)
        anchorHandler(containerView, childController.view)
        childController.didMove(toParent: self)
    }
    
    func removeChild(_ childController: UIViewController) {
        childController.willMove(toParent: nil)
        childController.view.removeFromSuperview()
        childController.removeFromParent()
    }
    
    func add(to parentViewController: UIViewController, parentContainerView: UIView, anchorHandler: @escaping (_ subView: UIView, _ parentView: UIView) -> Void) {
        parentViewController.addChild(self)
        parentContainerView.addSubview(self.view)
        anchorHandler(self.view, parentContainerView)
        self.didMove(toParent: parentViewController)
    }
    
    func removeFromParentViewController() {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
