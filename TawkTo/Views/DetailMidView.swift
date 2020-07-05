//
//  DetailMidView.swift
//  TawkTo
//
//  Created by robert ordiz on 7/6/20.
//  Copyright © 2020 robert ordiz. All rights reserved.
//

import Foundation
import UIKit

class DetailMidView: UIView {
    private var nameLabel = UILabel()
    private var companyLabel = UILabel()
    private var blogLabel = UILabel()
    var data: UsersModel! = nil {
        didSet {
            if let name = data.name {
                nameLabel.text = "name:  \(name)"
            }
            
            if let company = data.company {
                companyLabel.text = "company:  \(company)"
            }
            
            if let blog = data.blog {
                blogLabel.text = "blog:  \(blog)"
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        let containerView = UIView()
        containerView.dropShadow(scale: true)
        containerView.backgroundColor = .white
        self.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 7).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -7).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        
        nameLabel.text = "name:  "
        nameLabel.lineBreakMode = .byClipping
        nameLabel.numberOfLines = 2
        nameLabel.textAlignment = .left
        nameLabel.backgroundColor = .clear
        nameLabel.textColor = .darkGray
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        containerView.addSubview(nameLabel)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5).isActive = true
        nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        companyLabel.text = "company:  "
        companyLabel.lineBreakMode = .byClipping
        companyLabel.numberOfLines = 2
        companyLabel.textAlignment = .left
        companyLabel.backgroundColor = .clear
        companyLabel.textColor = .darkGray
        companyLabel.font = UIFont.systemFont(ofSize: 16)
        containerView.addSubview(companyLabel)

        companyLabel.translatesAutoresizingMaskIntoConstraints = false
        companyLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5).isActive = true
        companyLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5).isActive = true
        companyLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        companyLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        blogLabel.text = "blog:  "
        blogLabel.lineBreakMode = .byClipping
        blogLabel.numberOfLines = 2
        blogLabel.textAlignment = .left
        blogLabel.backgroundColor = .clear
        blogLabel.textColor = .darkGray
        blogLabel.font = UIFont.systemFont(ofSize: 16)
        containerView.addSubview(blogLabel)

        blogLabel.translatesAutoresizingMaskIntoConstraints = false
        blogLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5).isActive = true
        blogLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5).isActive = true
        blogLabel.topAnchor.constraint(equalTo: companyLabel.bottomAnchor, constant: 5).isActive = true
        blogLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
