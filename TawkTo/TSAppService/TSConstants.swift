//
//  VCConstants.swift
//  Vehicle Checklist
//
//  Created by Robert on 06/02/2019.
//  Copyright © 2019 Robert. All rights reserved.
//

import Foundation

enum TSAPIEndpoints: String, CustomStringConvertible {
    var description: String {
        return rawValue
    }

    case getUsers = "users?since=0"
}

public func localizeLater(_ string: String) -> String {
    return string
}
