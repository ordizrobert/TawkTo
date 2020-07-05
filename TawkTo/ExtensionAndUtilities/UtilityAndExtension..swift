//
//  FontExtension.swift
//  Track-a-Shop
//
//  Created by robert ordiz on 4/29/20.
//  Copyright © 2020 robert ordiz. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

extension UIView {
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 3
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func colorizeViews() {
        for view in subviews {
            view.backgroundColor = UIColor.randomColor()
        }
    }
    
    func colorizeBorders() {
        for view in subviews {
            view.layer.borderWidth = 1.0
            view.layer.borderColor = UIColor.randomColor().cgColor
        }
    }
    
    func colorizeBordersRecursive(view: UIView) {
        for subview in view.subviews {
            subview.layer.borderWidth = 1.0
            subview.layer.borderColor = UIColor.randomColor().cgColor
            colorizeBordersRecursive(view: subview)
        }
    }   
}

extension Data {
    func utf8String() -> String {
        return String(data: self, encoding: .utf8) ?? ""
    }
}

extension UIImageView {
    func vc_setImage(urlString: String?, placeholderImageName: String, completion: (() -> Void)? = nil) {
        guard let urlString = urlString else {
            image = UIImage(named: placeholderImageName)
            return
        }
        guard let url = URL(string: urlString) else {
            image = UIImage(named: placeholderImageName)
            return
        }
        
        sd_setImage(with: url, placeholderImage: UIImage(named: placeholderImageName)) { (_, _, _, _) in
            completion?()
        }
    }
}

extension KeyedDecodingContainer {
    
    func safeStringDecode(forKey key: K) throws -> String? {
        do {
            guard let string = try decodeIfPresent(String.self, forKey: key) else {
                return nil
            }
            
            if string.count > 0 {
                return string
            }
            
            return nil
            
        } catch {
            return try decodeIfPresent(String.self, forKey: key)
        }
    }
    
    func safeIntDecode(forKey key: K) throws -> Int? {
        do {
            guard let string = try decodeIfPresent(String.self, forKey: key) else {
                return nil
            }
            return Int(string)
        } catch {
            return try decodeIfPresent(Int.self, forKey: key)
        }
    }
    
    func safeFloatDecode(forKey key: K) throws -> Float? {
        do {
            guard let string = try decodeIfPresent(String.self, forKey: key) else {
                return nil
            }
            return Float(string)
        } catch {
            return try decodeIfPresent(Float.self, forKey: key)
        }
    }
    
    func safeStringIntDecode(forKey key: K) throws -> String? {
        do {
            guard let int = try decodeIfPresent(Int.self, forKey: key) else {
                return nil
            }
            return String(describing: int)
        } catch {
            return try decodeIfPresent(String.self, forKey: key)
        }
    }
    
    func safeStringFloatDecode(forKey key: K) throws -> String? {
        do {
            guard let float = try decodeIfPresent(Float.self, forKey: key) else {
                return nil
            }
            return String(describing: float)
        } catch {
            return try decodeIfPresent(String.self, forKey: key)
        }
    }
    
    func safeBoolDecode(forKey key: K)  throws -> Bool? {
        do {
            guard let string = try decodeIfPresent(String.self, forKey: key) else {
                return nil
            }
            let lowercased = string.lowercased()
            if lowercased == "true" {
                return true
            }
            if lowercased == "1" {
                return true
            }
            if lowercased == "yes" {
                return true
            }
            return false
        } catch {
            return try decodeIfPresent(Bool.self, forKey: key)
        }
    }
    
    func safeIntBoolDecode(forKey key: K)  throws -> Bool? {
        do {
            guard let intValue = try decodeIfPresent(Int.self, forKey: key) else {
                return nil
            }
            
            if intValue > 0 {
                return true
            }
            
            return false
        } catch {
            return try decodeIfPresent(Bool.self, forKey: key)
        }
    }
}

extension Encodable {
    func jsonString() -> String {
        guard let data = try? JSONEncoder().encode(self) else {
            return ""
        }
        return data.utf8String()
    }
}

extension Decodable {
    func describing() -> String {
        return String(describing: self)
    }
}

