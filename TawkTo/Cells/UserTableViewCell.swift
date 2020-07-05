//
//  UsersCell.swift
//  TawkTo
//
//  Created by robert ordiz on 7/5/20.
//  Copyright © 2020 robert ordiz. All rights reserved.
//

import Foundation
import UIKit

class UserTableViewCell: UITableViewCell {
    private let containerView = UIView()
    var userProfileImage = UIImageView()
    private var userNameLabel = UILabel()
    private var detailsLabel = UILabel()
    private var notesImage = UIImageView()
    var user: UsersModel! = nil {
        didSet {
            userProfileImage.sd_setImage(with: URL(string: user.avatar_url!), placeholderImage: UIImage(named: "user"), completed: nil)
            userNameLabel.text = user.login
            detailsLabel.text = user.type
            
            if AppCommonHandler().checkExistingUserID(predicate: NSPredicate(format: "id = \(user.id ?? 0)")) {
                notesImage.isHidden = false
            } else {
                notesImage.isHidden = true
            }
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }
    
    class func cellReuseID() -> String {
        return String(describing: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setupUI() {
        containerView.dropShadow(scale: true)
        containerView.backgroundColor = .white
        self.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 7).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -7).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        
        userProfileImage.layer.cornerRadius = 40
        userProfileImage.layer.masksToBounds = true
        userProfileImage.contentMode = .scaleAspectFill
        userProfileImage.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        containerView.addSubview(userProfileImage)
        
        userProfileImage.translatesAutoresizingMaskIntoConstraints = false
        userProfileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        userProfileImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        userProfileImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        userProfileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        
        userNameLabel.lineBreakMode = .byClipping
        userNameLabel.numberOfLines = 2
        userNameLabel.textAlignment = .left
        userNameLabel.backgroundColor = .clear
        userNameLabel.textColor = .darkGray
        userNameLabel.font = UIFont.systemFont(ofSize: 16)
        containerView.addSubview(userNameLabel)

        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.leadingAnchor.constraint(equalTo: userProfileImage.trailingAnchor, constant: 10).isActive = true
        userNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -45).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: userProfileImage.topAnchor).isActive = true
        userNameLabel.bottomAnchor.constraint(equalTo: userProfileImage.centerYAnchor).isActive = true
        
        detailsLabel.textAlignment = .left
        detailsLabel.backgroundColor = .clear
        detailsLabel.textColor = .darkGray
        detailsLabel.font = UIFont.systemFont(ofSize: 16)
        containerView.addSubview(detailsLabel)
        
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.leadingAnchor.constraint(equalTo: userProfileImage.trailingAnchor, constant: 10).isActive = true
        detailsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -45).isActive = true
        detailsLabel.topAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        detailsLabel.bottomAnchor.constraint(equalTo: userProfileImage.bottomAnchor).isActive = true
        
        notesImage.isHidden = true
        notesImage.image = UIImage(named: "notes")
        notesImage.contentMode = .scaleAspectFit
        containerView.addSubview(notesImage)
        
        notesImage.translatesAutoresizingMaskIntoConstraints = false
        notesImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        notesImage.widthAnchor.constraint(equalToConstant: 25).isActive = true
        notesImage.heightAnchor.constraint(equalToConstant: 25).isActive = true
        notesImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIImage {
    func invertedImage() -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        let ciImage = CoreImage.CIImage(cgImage: cgImage)
        guard let filter = CIFilter(name: "CIColorInvert") else { return nil }
        filter.setDefaults()
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        let context = CIContext(options: nil)
        guard let outputImage = filter.outputImage else { return nil }
        guard let outputImageCopy = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        return UIImage(cgImage: outputImageCopy, scale: self.scale, orientation: .up)
    }
}
