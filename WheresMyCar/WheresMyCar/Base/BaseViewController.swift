//
//  BaseViewController.swift
//  WheresMyCar
//
//  Created by AllenLai on 2019/4/2.
//  Copyright © 2019 EggWin. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    // MARK: - ViewController lifecycle
    deinit {
        printLog("\(self.className) deinit")
    }
    
    override func loadView() {
        super.loadView()
        printLog("\(self.className) loadView")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        printLog("\(self.className) viewDidLoad")
        
        setupAuth()
        setupUI()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printLog("\(self.className) viewWillAppear:")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        printLog("\(self.className) viewDidAppear:")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        printLog("\(self.className) viewWillLayoutSubviews")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        printLog("\(self.className) viewDidLayoutSubviews")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        printLog("\(self.className) viewWillDisappear:")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        printLog("\(self.className) viewDidDisappear:")
    }
    
    // MARK: - Inherit method
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Public method
    func setupAuth() {
        printLog("\(self.className) setupAuth")
    }
    
    func setupUI() {
        printLog("\(self.className) setupUI")
        
        view.backgroundColor = .white
        title = self.className
    }
    
    func setupData() {
        printLog("\(self.className) setupData")
    }
}
