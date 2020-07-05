//
//  VCBaseService.swift
//  Vehicle Checklist
//
//  Created by Robert on 06/02/2019.
//  Copyright © 2019 Robert. All rights reserved.
//

import UIKit

enum APIStatus: Int {
    case success
    case error
    case failed
}

struct ResponseData<T> {
    var decoded: T?
    var raw: Data?
    
    func jsonObject<O: Decodable>() -> O? {
        guard let raw = raw else { return nil }
        let parsedData = try? JSONDecoder().decode(O.self, from: raw)
        return parsedData
    }
    
    func processDecodedData<Result>(using dataProcessor: DataProcessor<T, Result>) -> Result? {
        guard let data = decoded else {
            return nil
        }
        return dataProcessor.process(data)
    }
    
}

struct APIResponse<T: Decodable> {
    var apiStatus: APIStatus!
    var data: ResponseData<T>
    var error: Error?
}

enum HTTPVerb: String {
    case get
    case post
    case put
    case patch
    case delete
}

enum ParameterType: Int {
    case urlEncoded
    case json
    case multiPart
}

typealias InternalAPICompletionHandler = (Data?, Int, Error?) -> Void
typealias APICompletionHandler<D: Decodable> = (APIResponse<D>) -> Void

class TSBaseService {
    static var host: String?
    static var defaultHeaders: [String: String]?
    
    func internalRequest(urlRequest: URLRequest, completion: @escaping InternalAPICompletionHandler) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 80.0
        configuration.timeoutIntervalForResource = 80.0
        let urlSession = URLSession(configuration: configuration)
        let dataTask = urlSession.dataTask(with: urlRequest) { (data, urlResponse, error) in
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                return
            }
            DispatchQueue.main.async {
                completion(data, httpResponse.statusCode, error)
            }
        }
        dataTask.resume()
    }
}

extension TSBaseService {
    func request(urlString: String,
                 httpMethod: HTTPVerb,
                 parameters: [String: Any]? = nil,
                 headers: [String: String]? = nil,
                 parameterType: ParameterType,
                 completion: @escaping InternalAPICompletionHandler) {
        
        let urlRequest = urlRequestFrom(urlString: urlString, httpMethod: httpMethod, parameters: parameters, headers: headers, parameterType: parameterType)
        internalRequest(urlRequest: urlRequest, completion: completion)
    }
    
    func apiRequest(endPoint: String,
                    httpMethod: HTTPVerb = .get,
                    parameters: [String: Any]? = nil,
                    headers: [String: String]? = nil,
                    completion: @escaping InternalAPICompletionHandler) {
        assert(TSBaseService.host != nil, "Please define the host before making any request that is prefixed with \"apimobile\"")
        request(urlString: TSBaseService.host! + endPoint,
                httpMethod: httpMethod,
                parameters: parameters,
                parameterType: .urlEncoded,
                completion: completion)
    }
    
    func apiBodyRequest(endPoint: String,
                        httpMethod: HTTPVerb = .get,
                        postBody: [String: Any]? = nil,
                        headers: [String: String]? = nil,
                        completion: @escaping InternalAPICompletionHandler) {
        assert(TSBaseService.host != nil, "Please define the host before making any request that is prefixed with \"apimobile\"")
        request(urlString: TSBaseService.host! + endPoint,
                httpMethod: httpMethod,
                parameters: postBody,
                parameterType: .json,
                completion: completion)
    }
    
    func urlRequestFrom(urlString: String,
                        httpMethod: HTTPVerb,
                        parameters: [String: Any]? = nil,
                        headers: [String: String]? = nil,
                        multiPartData: [MultiPartdata]? = nil,
                        queryParametersSupportsArray: Bool = false,
                        parameterType: ParameterType) -> URLRequest {

        var tempURLString = urlString
        if httpMethod == .get {
            if let parameters = parameters {
                let append = tempURLString.contains("?") == true ? "&" : "?"
                tempURLString += "\(append)\(parameters.queryParametersArraySupported)"
            }
        }

        let url = URL(string: tempURLString)!
        var urlRequest = URLRequest(url: url)
        
//        if let accessToken = TSProfileManager.instance.profile {
//            let bearer = "Bearer " + accessToken.token!
//            urlRequest.setValue(bearer, forHTTPHeaderField: "Authorization")
//        }
        
        urlRequest.httpMethod = httpMethod.rawValue
        print(tempURLString)
        
        if let headers = headers {
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }

        if httpMethod != .get {
            switch parameterType {
            case .urlEncoded:
                urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                if let parameters = parameters {
                    if queryParametersSupportsArray {
                        urlRequest.httpBody = parameters.queryParametersArraySupported.data(using: String.Encoding.utf8)
                    } else {
                        urlRequest.httpBody = parameters.queryParameters.data(using: String.Encoding.utf8)
                    }
                }
            case .json:
                urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                if let parameters = parameters {
                    urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
                }
            case .multiPart:
                let body = NSMutableData()
                let boundary = TSBaseService.generateBoundaryString()
                urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                
                if let multiData = multiPartData {
                    for data in multiData {
                        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                        body.append("Content-Disposition: form-data; name=\"\(multiPartData![0].name ?? "data")\"; filename=\"\(data.name ?? "data")\"\r\n".data(using: String.Encoding.utf8)!)
                        body.append("Content-Type: \(data.mimeType ?? "")\r\n\r\n".data(using: String.Encoding.utf8)!)
                        body.append(data.data!)
                        body.append("\r\n".data(using: String.Encoding.utf8)!)
                        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
                    }
                }
                
                if let parameters = parameters {
                    for (key, value) in parameters {
                        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                        body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                        body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
                    }
                }

                urlRequest.httpBody = body as Data
            }
        }

        return urlRequest
    }
    
    static func apiURLWithEndPoint(endPoint: String) -> String {
        guard let host = TSBaseService.host else {
            return ""
        }
        
        return host + endPoint
    }
    
    class func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}

extension Dictionary {
    var queryParameters: String {
        let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:&=+$,/?%#[] ").inverted)
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!,
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
    
    var queryParametersArraySupported: String {
        var parts: [String] = []
        for (key, value) in self {
            if let array = value as? [Any] {
                if array.isEmpty {
                    parts.append(String(format: "%@=%@",
                                        String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                                        "[]".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!))
                }
                else {
                    for value in array {
                        let part = String(format: "%@=%@",
                                          String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                                          String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                        parts.append(part as String)
                    }
                }
            } else {
                let part = String(format: "%@=%@",
                                  String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                                  String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                parts.append(part as String)
            }
        }
        return parts.joined(separator: "&")
    }
}
