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
        
        let request = APIRequest(method: .get, path: .posts)
        APIClient().perform(request) { (result) in
            switch result {
            case .success(let response):
                if let response = try? response.decode(to: [Post].self) {
                    let posts = response.body
                    print("Received posts: \(posts.first?.title ?? "")")
                } else {
                    print("Failed to decode response")
                }
            case .failure:
                print("Error perform network request")
            }
        }

        // I can do something(ex: call Initial API) in here.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let strongSelf = self else { return }
            
            let tabBarController = ALTabBarController()
            tabBarController.setupViewControllers([
                ViewControllerInfo(hasNavigation: true, viewController: PinCarViewController(), tabBarItem: UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)),
                ViewControllerInfo(hasNavigation: true, viewController: SettingsViewController(), tabBarItem: UITabBarItem(tabBarSystemItem: .contacts, tag: 1))
            ])
            strongSelf.present(tabBarController, animated: true, completion: nil)
        }
    }
}
