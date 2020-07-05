//
//  BaseViewController.swift
//  Track-a-Shop
//
//  Created by robert ordiz on 7/5/20.
//  Copyright © 2020 robert ordiz. All rights reserved.
//

import Foundation
import JGProgressHUD

class BaseViewController: UIViewController {
    var hud = JGProgressHUD(style: .light)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = TSColorUtils.TSNavGreen
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.navigationController?.navigationBar.backgroundColor = .blue
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    func setupViews() {
    }
    
    func showHUD(status: String) {
        //view.isUserInteractionEnabled = false
        self.hud.textLabel.text = status
        self.hud.show(in: self.view)
    }
    
    func dismissHUD(dismissMessage: String? = nil, interval: Double? = 0.0, completion: @escaping (Bool) -> ()) {
        //view.isUserInteractionEnabled = true
        hud.textLabel.text = dismissMessage
        hud.dismiss(afterDelay: 0.4)
    }
    
    func showSimpleAlert(withTitle alertTitle: String, withMessage alertMessage: String, withOKButtonTitle okButtonTitle: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: okButtonTitle, style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
