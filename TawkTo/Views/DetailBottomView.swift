//
//  DetailBottomView.swift
//  TawkTo
//
//  Created by robert ordiz on 7/6/20.
//  Copyright © 2020 robert ordiz. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DetailBottomView: UIView {
    let textView = UITextView()
    var data: UsersModel! = nil {
        didSet {
            fetchNoteData()
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
        
        textView.delegate = self
        textView.returnKeyType = .done
        textView.layer.cornerRadius = 3.0
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.5
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = .white
        textView.textColor = .darkGray
        textView.isEditable = true
        textView.isScrollEnabled = true
        containerView.addSubview(textView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 2).isActive = true
        textView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -2).isActive = true
        textView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -2).isActive = true
        textView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 2).isActive = true
    }
    
    func fetchNoteData() {
        let historyData: [NSManagedObject] = AppCommonHandler().fetchData(predicate: NSPredicate(format: "id =  \(data.id ?? 0)"))
        
        if historyData.count != 0 {
            if let data = historyData[0].value(forKey: "note") as? String {
                textView.text = data
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailBottomView: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        if textView.text.last == "\n" {
            textView.text.removeLast()
            textView.resignFirstResponder()
        }
    }
}
