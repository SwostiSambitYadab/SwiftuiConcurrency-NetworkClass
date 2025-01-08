//
//  RouterProtocol.swift
//  SwiftuiConcurrency
//
//  Created by hb on 07/01/25.
//

import Foundation

public typealias RequestParameters = [String: Any]
public typealias RequestHeaders = [String: String]

public protocol RouterProtocol {
        
    var method: HTTPMethod { get }
    var baseUrlString: String { get }
    
    var path: String { get }
    var parameters: RequestParameters? { get }
    var headers: RequestHeaders? { get }
    var arrayParameters: [Any]? { get }
    var requestType: RequestType { get }
    
    var files: [MultiPartData]? { get }
    var deviceInfo: RequestParameters? { get }
}


public enum RequestType {
    case data
    case download
    case upload
}


public extension RouterProtocol {
    
    var baseUrlString: String {
        return "http://www.sqwidapp.com/WS/"
    }
    
    var arrayParameters: [Any]? {
        return nil
    }
    
    func asURLRequest() -> URLRequest? {
        
        guard var urlComponents = URLComponents(string: baseUrlString) else {
            return nil
        }
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url?.appending(path: path) else {
            return nil
        }
        
        var request = URLRequest(
            url: path.contains("http://") || path.contains("https://") ? URL(string: path)! : url.appending(path: path),
            cachePolicy: .reloadIgnoringLocalCacheData,
            timeoutInterval: 30
        )
        
        
        if requestType == .upload {
            request.setValue("multipart/form-data; boundary=\(UUID().uuidString)", forHTTPHeaderField: "Content-Type")
        }
        
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = requestType != .upload ? jsonBody : formDataBody
        return request
    }
}

extension RouterProtocol {
    private var queryItems: [URLQueryItem]? {
        guard method == .get, let parameters = parameters else {
            return nil
        }
        
        return parameters.map { (key: String, value: Any?) -> URLQueryItem in
            let valueString = String(describing: value)
            return URLQueryItem(name: key, value: valueString)
        }
    }
        
    private var formDataBody: Data? {
        
        guard [.post].contains(method), let parameters = parameters else {
            return nil
        }
        
        let httpBody = NSMutableData()
        let boundary = NetworkService.boundaryConstant

        if let files, files.count > 0 {
            
            for file in files {
                httpBody.append(dataFormField(named: file.fileName, data: file.data, mimeType: file.mimeType, boundary: boundary))
            }
            
        } else {
            for (key, value) in parameters {
                httpBody.append(textFormField(named: key, value: value as! String, boundary: boundary))
            }
        }
        httpBody.append("--\(boundary)--")
        return httpBody as Data
    }
    
    private var jsonBody: Data? {
        guard [.post, .put, .patch].contains(method), let parameters else {
            return nil
        }
        
        var jsonBody: Data?
        
        do {
            jsonBody = try JSONSerialization.data(withJSONObject: parameters,
                                                  options: .prettyPrinted)
        } catch {
            print(error)
        }
        return jsonBody
    }
}


extension RouterProtocol {
    private func textFormField(named name: String, value: Any, boundary: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "Content-Type: text/plain; charset=ISO-8859-1\r\n"
        fieldString += "Content-Transfer-Encoding: 8bit\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"

        return fieldString
    }

    private func dataFormField(named name: String,
                               data: Data,
                               mimeType: String, boundary: String) -> Data {
        let fieldData = NSMutableData()

        fieldData.append("--\(boundary)\r\n")
        fieldData.append("Content-Disposition: form-data; name=\"\(name)\"\r\n")
        fieldData.append("Content-Type: \(mimeType)\r\n")
        fieldData.append("\r\n")
        fieldData.append(data)
        fieldData.append("\r\n")

        return fieldData as Data
    }
}

extension NSMutableData {
    func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
