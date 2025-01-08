//
//  NetworkService.swift
//  SwiftuiConcurrency
//
//  Created by hb on 07/01/25.
//

import Foundation


public protocol NetworkProtocol {
    var session: URLSession { get }
    func dataRequest<Model: WSResponseData>(with request: RouterProtocol) async throws -> WSResponse<Model>
}

final class NetworkService: NetworkProtocol {
    
    static let boundaryConstant = "Boundary-\(UUID().uuidString)"
    var session: URLSession
    
    init(_ session: URLSession = .shared) {
        self.session = session
    }
    
    public convenience init(config: URLSessionConfiguration) {
        self.init()
        self.session = URLSession(configuration: config)
    }
}

extension NetworkService  {
    func dataRequest<Model: WSResponseData>(with request: RouterProtocol) async throws -> WSResponse<Model> {
        
        // ---- Checking for connection ---- //
        guard NetworkMonitor.shared.isReachable else {
            throw NetworkError.requestError(errorMessage: "It seems you're not connected to Internet")
        }

        print("ROUTER BASE", request.baseUrlString)
        print("ROUTER PARAMETERS", request.parameters ?? [:])
        print("ROUTER PATH", request.path)
        print("ROUTER VERB", request.method)
        
        // ---- Trying to create URLRequest ---- //
        guard let request = request.asURLRequest() else {
            throw NetworkError.requestError(errorMessage: "Server is not responding! Please try after sometime.")
        }
        
        
        do {
            let (data, response) = try await session.data(for: request)
            
            // Response code is not in the acceptable range
            if let response = response as? HTTPURLResponse, !response.statusCode.isSuccess  {
                debugPrint("STATUS CODE :: \(response.statusCode)")
                switch response.statusCode {
                case 400...499:
                    throw NetworkError.clientError(statusCode: response.statusCode)
                    
                case 500...599:
                    throw NetworkError.serverError(statusCode: response.statusCode)
                    
                default:
                    throw NetworkError.other(statusCode: response.statusCode, error: nil)
                }
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                debugPrint("\nRESPONSE:")
                debugPrint(responseString)
            }
            
            let decoder = JSONDecoder()
            let decodedValue = try decoder.decode(WSResponse<Model>.self, from: data)
            return decodedValue
        } catch {
            let error = error as NSError
            if error._code == NSURLErrorTimedOut || error._code == NSURLErrorNetworkConnectionLost {
                debugPrint("Time Out/Connection Lost Error")
                throw NetworkError.requestError(errorMessage: "Connection Time Out or Lost.\nPlease try again.")
            }
            
            throw NetworkError.other(statusCode: nil, error: error)
        }
    }
}
