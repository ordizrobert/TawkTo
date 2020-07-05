//
//  UserRequestHandler.swift
//  TawkTo
//
//  Created by robert ordiz on 7/5/20.
//  Copyright © 2020 robert ordiz. All rights reserved.
//

import Foundation
import UIKit

class UserRequestHandler {
    func getUsers(since: Int? = 0, completion: @escaping ([UsersModel]) -> ()) {
        AppCommonHandler().topViewController().showHUD(status: "loading")
        TSAppService<[UsersModel]>().apiFetchString(endPoint: endPointComposer(since: since), httpMethod: .get) { (apiResponse) in
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
    
    func endPointComposer(since: Int? = 0) -> String {
        return "users?since=\(since ?? 0)"
    }
}
