//
//  VCCodableService.swift
//  Vehicle Checklist
//
//  Created by Robert on 06/02/2019.
//  Copyright © 2019 Robert. All rights reserved.
//

import UIKit

typealias InternalCodableAPICompletionHandler<ExpectedResponse: Decodable> = (ResponseData<ExpectedResponse>, Int, Error?) -> Void

class CodableService<ExpectedResponse: Decodable>: TSBaseService {
    
    private func internalCodableRequest(urlRequest: URLRequest, completion: @escaping InternalCodableAPICompletionHandler<ExpectedResponse>) {
        if Reachability.isConnectedToNetwork() {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 300.0
            configuration.timeoutIntervalForResource = 300.0
            let urlSession = URLSession(configuration: configuration)
            let dataTask = urlSession.dataTask(with: urlRequest) { (data, urlResponse, error) in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    if error?.localizedDescription == "The request timed out." {
                        DispatchQueue.main.async {
                            completion(ResponseData(decoded: nil, raw: data), 1001, error)
                            _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                                //AppCommonHandler().returnTopMostViewController().showSimpleAlert(withTitle: "Request timed out", withMessage: "Please check internet connection.", withOKButtonTitle: "OK")
                            }
                        }
                    }
                    
                    return
                }
                
                DispatchQueue.main.async {
                    guard httpResponse.statusCode <= 300 else {
                        completion(ResponseData(decoded: nil, raw: data), httpResponse.statusCode, error)
                        return
                    }
                    
                    if let data1 = data {
                        do {
                            let parsedData = try JSONDecoder().decode(ExpectedResponse.self, from: data1)
                            completion(ResponseData(decoded: parsedData, raw: data1), httpResponse.statusCode, error)
                        } catch {
                            completion(ResponseData(decoded: nil, raw: data), httpResponse.statusCode, error)
                        }
                    } else {
                        completion(ResponseData(decoded: nil, raw: nil), httpResponse.statusCode, error)
                    }
                }
            }
            
            dataTask.resume()
        } else {
            completion(ResponseData(decoded: nil, raw: Data()), 1001, Error.self as? Error)
            _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                //AppCommonHandler().returnTopMostViewController().showSimpleAlert(withTitle: "Message", withMessage: "Please check internet connection.", withOKButtonTitle: "OK")
            }
        }
    }
    
    func codableRequest<EncodableParameter: Encodable>(urlString: String,
                                                       httpMethod: HTTPVerb,
                                                       parameters: EncodableParameter? = nil,
                                                       headers: [String: String]? = nil,
                                                       parameterType: ParameterType,
                                                       completion: @escaping InternalCodableAPICompletionHandler<ExpectedResponse>) {
        
        do {
            let data = try JSONEncoder().encode(parameters)
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [String: Any]
            let urlRequest = urlRequestFrom(urlString: urlString, httpMethod: httpMethod, parameters: json, headers: headers, parameterType: parameterType)
            internalCodableRequest(urlRequest: urlRequest, completion: completion)
        } catch {
            
        }
    }
    
    func apiCodableRequest<EncodableParameter: Encodable>(endPoint: String,
                                                          httpMethod: HTTPVerb = .get,
                                                          parameters: EncodableParameter? = nil,
                                                          headers: [String: String]? = nil,
                                                          parameterType: ParameterType = .json,
                                                          completion: @escaping InternalCodableAPICompletionHandler<ExpectedResponse>) {
        do {
            let data = try JSONEncoder().encode(parameters)
            let dictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [String: Any]
            let urlString = TSBaseService.host! + endPoint
            var urlRequest = urlRequestFrom(urlString: urlString, httpMethod: httpMethod, parameters: dictionary, headers: headers, parameterType: parameterType)
            if let defaultHeaders = TSBaseService.defaultHeaders {
                for (key, value) in defaultHeaders {
                    urlRequest.addValue(value, forHTTPHeaderField: key)
                }
            }
            internalCodableRequest(urlRequest: urlRequest, completion: completion)
        } catch {
            
        }
        
    }
    
    func defaultRequest(urlString: String,
                        httpMethod: HTTPVerb = .get,
                        parameters: [String: Any]? = nil,
                        headers: [String: String]? = nil,
                        parameterType: ParameterType = .json,
                        completion: @escaping InternalCodableAPICompletionHandler<ExpectedResponse>) {
        let urlRequest = urlRequestFrom(urlString: urlString, httpMethod: httpMethod, parameters: parameters, headers: headers, parameterType: parameterType)
        internalCodableRequest(urlRequest: urlRequest, completion: completion)
    }
    
    func apiDefaultRequest(endPoint: String,
                           httpMethod: HTTPVerb = .get,
                           parameters: [String: Any]? = nil,
                           headers: [String: String]? = nil,
                           parameterType: ParameterType = .urlEncoded,
                           data: [MultiPartdata]? = nil,
                           queryParametersSupportsArray: Bool? = false,
                           completion: @escaping InternalCodableAPICompletionHandler<ExpectedResponse>) {
        let urlString = TSBaseService.host! + endPoint
        var urlRequest = urlRequestFrom(urlString: urlString, httpMethod: httpMethod, parameters: parameters, headers: headers, multiPartData: data, queryParametersSupportsArray: queryParametersSupportsArray!, parameterType: parameterType)
        if let defaultHeaders = TSBaseService.defaultHeaders {
            for (key, value) in defaultHeaders {
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        internalCodableRequest(urlRequest: urlRequest, completion: completion)
    }
}
