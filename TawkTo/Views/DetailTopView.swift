//
//  DetailTopView.swift
//  TawkTo
//
//  Created by robert ordiz on 7/6/20.
//  Copyright © 2020 robert ordiz. All rights reserved.
//

import Foundation
import UIKit

class DetailTopView: UIView {
    private var followersLabel = UILabel()
    private var followingLabel = UILabel()
    var data: UsersModel! = nil {
        didSet {
            if data.following! > 0 {
                followingLabel.text = "Following: \(data.following ?? 0)"
            }
            
            if data.followers! > 0 {
                followersLabel.text = "Followers: \(data.followers ?? 0)"
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
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40).isActive = true
        containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        
        followersLabel.text = "Followers: 0"
        followersLabel.lineBreakMode = .byClipping
        followersLabel.numberOfLines = 2
        followersLabel.textAlignment = .center
        followersLabel.backgroundColor = .clear
        followersLabel.textColor = .darkGray
        followersLabel.font = UIFont.systemFont(ofSize: 16)
        self.addSubview(followersLabel)

        followersLabel.translatesAutoresizingMaskIntoConstraints = false
        followersLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor ).isActive = true
        followersLabel.trailingAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        followersLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 7).isActive = true
        followersLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -7).isActive = true
        
        followingLabel.text = "Following: 0"
        followingLabel.lineBreakMode = .byClipping
        followingLabel.numberOfLines = 2
        followingLabel.textAlignment = .center
        followingLabel.backgroundColor = .clear
        followingLabel.textColor = .darkGray
        followingLabel.font = UIFont.systemFont(ofSize: 16)
        self.addSubview(followingLabel)

        followingLabel.translatesAutoresizingMaskIntoConstraints = false
        followingLabel.leadingAnchor.constraint(equalTo: containerView.centerXAnchor ).isActive = true
        followingLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        followingLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 7).isActive = true
        followingLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -7).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
