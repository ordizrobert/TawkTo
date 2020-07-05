//
//  TSColorUtils.swift
//  Track-a-Shop
//
//  Created by robert ordiz on 4/29/20.
//  Copyright © 2020 robert ordiz. All rights reserved.
//

import Foundation
import UIKit

struct TSColorUtils {
    static var TSNavGreen: UIColor {
        return #colorLiteral(red: 0, green: 0.7144959569, blue: 0.224520117, alpha: 1)
    }
}

extension UIColor {
    static func randomColor() -> UIColor {
        let r = CGFloat(TSRandomizer.int(max: 255)) / 255.0
        let g = CGFloat(TSRandomizer.int(max: 255)) / 255.0
        let b = CGFloat(TSRandomizer.int(max: 255)) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    convenience init(r: Int, g: Int, b: Int) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}

class TSRandomizer {
    class func int(max: Int = 99) -> Int {
        return Int(arc4random_uniform(UInt32(max)))
    }
    
    static func string(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
    
    static func words(length: Int = 20, wordCount: Int = 10) -> String {
        var randomString: String = ""
        for _ in 0..<wordCount {
            randomString += string(length: length) + " "
        }
        return randomString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
