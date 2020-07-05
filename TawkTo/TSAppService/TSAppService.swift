//
//  VCAppServices.swift
//  Vehicle Checklist
//
//  Created by Robert on 06/02/2019.
//  Copyright © 2019 Robert. All rights reserved.
//

import UIKit

class TSAppService<D: Decodable>: TSResponseHandler<D> {
    private let codableService = CodableService<D>()
    
    func apiFetch(endPoint: TSAPIEndpoints,
                  httpMethod: HTTPVerb = .get,
                  parameters: [String: Any]? = nil,
                  headers: [String: String]? = nil,
                  parameterType: ParameterType = .urlEncoded,
                  data: [MultiPartdata]? = nil,
                  queryParametersSupportsArray: Bool? = false,
                  completion: @escaping APICompletionHandler<D>) {
        codableService.apiDefaultRequest(endPoint: endPoint.rawValue, httpMethod: httpMethod, parameters: parameters, headers: headers, parameterType: parameterType, data: data, queryParametersSupportsArray: queryParametersSupportsArray) { (response, statusCode, error) in
            let apiResponse = self.basicResponseHandler(response: response, error: error)
            completion(apiResponse)
        }
    }
    
    func apiFetchEncodable<E: Encodable>(endPoint: TSAPIEndpoints,
                                         httpMethod: HTTPVerb = .get,
                                         parameters: E,
                                         headers: [String: String]? = nil,
                                         completion: @escaping APICompletionHandler<D>) {
        codableService.apiCodableRequest(endPoint: endPoint.rawValue, httpMethod: httpMethod, parameters: parameters, headers: headers) { (response, _, error) in
            let apiResponse = self.basicResponseHandler(response: response, error: error)
            completion(apiResponse)
        }
    }
    
    func apiFetchString(endPoint: String,
                  httpMethod: HTTPVerb = .get,
                  parameters: [String: Any]? = nil,
                  headers: [String: String]? = nil,
                  parameterType: ParameterType = .urlEncoded,
                  completion: @escaping APICompletionHandler<D>) {
        codableService.apiDefaultRequest(endPoint: endPoint, httpMethod: httpMethod, parameters: parameters, headers: headers, parameterType: parameterType) { (response, _, error) in
            let apiResponse = self.basicResponseHandler(response: response, error: error)
            completion(apiResponse)
        }
    }
    
    func apiFetchStringEncodable<E: Encodable>(endPoint: String,
                                         httpMethod: HTTPVerb = .get,
                                         parameters: E,
                                         headers: [String: String]? = nil,
                                         completion: @escaping APICompletionHandler<D>) {
        codableService.apiCodableRequest(endPoint: endPoint, httpMethod: httpMethod, parameters: parameters, headers: headers) { (response, _, error) in
            let apiResponse = self.basicResponseHandler(response: response, error: error)
            completion(apiResponse)
        }
    }
}

class TSResponseHandler<ExpectedResponse: Decodable> {
    var shouldAppend = true
    
    init(persist: Bool = true, append: Bool = true) {
        self.shouldAppend = append
    }
    
    fileprivate func basicResponseHandler(response: ResponseData<ExpectedResponse>, error: Error?) -> APIResponse<ExpectedResponse> {
        var apiResponse = APIResponse<ExpectedResponse>(apiStatus: .success, data: response, error: error)
        guard error == nil else {
            apiResponse.apiStatus = .error
//            print(error.debugDescription)
            return apiResponse
        }
        guard response.decoded != nil else {
            apiResponse.apiStatus = .failed
            return apiResponse
        }
        return apiResponse
    }
}

class DataProcessor<D: Decodable, Result: Decodable> {
    func process(_ object: D) -> Result? {
        // For overriding
        return nil
    }
}
