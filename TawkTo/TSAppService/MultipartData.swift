//
//  MultipartData.swift
//  Vehicle Checklist
//
//  Created by Robert on 10/03/2019.
//  Copyright © 2019 Robert. All rights reserved.
//

import Foundation

import UIKit

class MultiPartdata {
    var data: Data?
    var mimeType: String?
    var name: String?
    var file_name: String?
    var stringValue: String?
    
    init(data: Data? = nil, mimeType: String, name: String, file_name: String, stringValue: String? = nil) {
        self.data = data
        self.mimeType = mimeType
        self.name = name
        self.file_name = file_name
        self.stringValue = stringValue
    }
}
