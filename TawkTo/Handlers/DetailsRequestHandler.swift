//
//  DetailsHandler.swift
//  TawkTo
//
//  Created by robert ordiz on 7/6/20.
//  Copyright © 2020 robert ordiz. All rights reserved.
//

import Foundation
import UIKit

class DetailsRequestHandler {
    func getDetails(name: String, completion: @escaping (UsersModel) -> ()) {
        AppCommonHandler().topViewController().showHUD(status: "loading")
        TSAppService<UsersModel>().apiFetchString(endPoint: endPointComposer(name: name), httpMethod: .get) { (apiResponse) in
            AppCommonHandler().topViewController().dismissHUD(dismissMessage: "", interval: nil) { (Bool) in }
            guard apiResponse.data.raw != nil else {
                return
            }
            
            guard apiResponse.data.decoded != nil else {
                return
            }
            
            completion(apiResponse.data.decoded!)
        }
    }
    
    func endPointComposer(name: String) -> String {
        return "users/\(name)"
    }
}
