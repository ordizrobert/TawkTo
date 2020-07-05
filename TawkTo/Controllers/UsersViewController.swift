//
//  UsersViewController.swift
//  TawkTo
//
//  Created by robert ordiz on 7/5/20.
//  Copyright © 2020 robert ordiz. All rights reserved.
//

import Foundation
import UIKit

class UsersViewController: BaseViewController {
    private var usersView = UsersView()
    private var searchBar: UISearchBar!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Users"
        setupSearchBar()
        AppCommonHandler().topViewController()
    }
    
    override func setupViews() {
        usersView.delegate = self
        view.addSubview(usersView)
        
        usersView.translatesAutoresizingMaskIntoConstraints = false
        usersView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        usersView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        usersView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        usersView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setupSearchBar() {
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 51))
        searchBar.barTintColor = .black
        searchBar.delegate = self
        searchBar.tintColor = .black
        searchBar.searchTextField.backgroundColor = .white
        self.navigationItem.titleView = searchBar

        let cancelToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        cancelToolBar.tintColor = TSColorUtils.TSNavGreen
        cancelToolBar.barStyle = .default
        cancelToolBar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelSearch))]
        cancelToolBar.sizeToFit()

        searchBar.inputAccessoryView = cancelToolBar
    }
    
    @objc func cancelSearch() {
        searchBar.text = ""
        searchBar.endEditing(true)
        usersView.searchText = searchBar.text!
    }
}

extension UsersViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        usersView.searchText = searchBar.text!
    }
}

extension UsersViewController: UsersViewDelegate {
    func didSelectUser(_ sender: UsersView, model: UsersModel) {
        let detail = UserDetailsViewController()
        detail.delegate = self
        detail.usersModel = model
        self.navigationController?.pushViewController(detail, animated: true)
    }
}

extension UsersViewController: UserDetailsViewControllerDelegate {
    func detailsDidUpdate(_ sender: UserDetailsViewController, model: UsersModel) {
        self.usersView.userChangeNotes = model
    }
}


