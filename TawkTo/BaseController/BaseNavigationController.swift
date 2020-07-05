//
//  BaseNavigationController.swift
//  TawkTo
//
//  Created by robert ordiz on 7/5/20.
//  Copyright © 2020 robert ordiz. All rights reserved.
//
import UIKit
import Foundation

class BaseNavigationController: UINavigationController, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "navigationBackIcon")
        viewController.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "navigationBackIcon")
        viewController.navigationController?.navigationBar.tintColor = .white
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
