//
//  LaunchViewController.swift
//  WheresMyCar
//
//  Created by AllenLai on 2019/4/2.
//  Copyright © 2019 EggWin. All rights reserved.
//

import UIKit

class LaunchViewController: BaseViewController {
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // I can do something(ex: call Initial API) in here.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let strongSelf = self else { return }
            
            let navigationController = ALNavigationController(rootViewController: MainViewController())
            strongSelf.present(navigationController, animated: true, completion: nil)
        }
    }
}
