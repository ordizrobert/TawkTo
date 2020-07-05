//
//  UserDetailsViewController.swift
//  TawkTo
//
//  Created by robert ordiz on 7/5/20.
//  Copyright © 2020 robert ordiz. All rights reserved.
//

import Foundation
import UIKit

protocol UserDetailsViewControllerDelegate: class {
    func detailsDidUpdate(_ sender: UserDetailsViewController, model: UsersModel)
}

class UserDetailsViewController: BaseViewController {
    weak var delegate: UserDetailsViewControllerDelegate?
    private var detailsView = DetailTopView()
    private var detailsMidView = DetailMidView()
    private var detailsBottomView = DetailBottomView()
    var usersModel: UsersModel!
    var detailsModel: UsersModel! = nil {
        didSet {
            detailsBottomView.data = detailsModel
            detailsMidView.data = detailsModel
            detailsView.data = detailsModel
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DetailsRequestHandler().getDetails(name: usersModel.login!) { (usersDetailsResponse) in
            self.detailsModel = usersDetailsResponse
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = usersModel.login
    }
    
    override func setupViews() {
        view.addSubview(detailsView)
        detailsView.translatesAutoresizingMaskIntoConstraints = false
        detailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        detailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        detailsView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        if UIScreen.main.nativeBounds.height > 2208 {
            detailsView.topAnchor.constraint(equalTo: view.topAnchor, constant: 95).isActive = true
        } else {
            detailsView.topAnchor.constraint(equalTo: view.topAnchor, constant: 51).isActive = true
        }
        
        view.addSubview(detailsMidView)
        detailsMidView.translatesAutoresizingMaskIntoConstraints = false
        detailsMidView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        detailsMidView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        detailsMidView.heightAnchor.constraint(equalToConstant: 96).isActive = true
        detailsMidView.topAnchor.constraint(equalTo: detailsView.bottomAnchor, constant: 10).isActive = true
        
        view.addSubview(detailsBottomView)
        detailsBottomView.translatesAutoresizingMaskIntoConstraints = false
        detailsBottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        detailsBottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        detailsBottomView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        detailsBottomView.topAnchor.constraint(equalTo: detailsMidView.bottomAnchor, constant: 10).isActive = true
        
        let saveButton = UIButton()
        saveButton.backgroundColor = TSColorUtils.TSNavGreen
        saveButton.layer.cornerRadius = 4.0
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.setTitle("save".uppercased(), for: .normal)
        saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        view.addSubview(saveButton)
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        saveButton.topAnchor.constraint(equalTo: detailsBottomView.bottomAnchor, constant: 10).isActive = true
    }
    
    @objc func saveAction() {
        let actionSheet = UIAlertController(title: "Message", message: returnMessage(), preferredStyle: .alert)
        actionSheet.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            if AppCommonHandler().checkExistingUserID(predicate: NSPredicate(format: "id = \(self.usersModel.id ?? 0)")) {
                if self.detailsBottomView.textView.text.count > 0 {
                    AppCommonHandler().updateData(updatedData: self.detailsBottomView.textView.text, userID: self.usersModel.id)
                } else {
                    AppCommonHandler().delete(userID: self.usersModel.id)
                }
            } else {
                if self.detailsBottomView.textView.text.count > 0 {
                    AppCommonHandler().saveData(data: self.detailsBottomView.textView.text, userID: self.usersModel.id)
                }
            }
            
            self.delegate?.detailsDidUpdate(self, model: self.usersModel)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func returnMessage() -> String {
        if AppCommonHandler().checkExistingUserID(predicate: NSPredicate(format: "id = \(self.usersModel.id ?? 0)")) {
            if self.detailsBottomView.textView.text.count > 0 {
                return "Are you sure you want to save this note?"
            } else {
                return "Are you sure you want to remove the existing note?"
            }
        } else {
            if self.detailsBottomView.textView.text.count > 0 {
                return "Are you sure you want to save this note?"
            } else {
                return "Please type your notes for this user."
            }
        }
    }
}
