//
//  NetworkError.swift
//  SwiftuiConcurrency
//
//  Created by hb on 07/01/25.
//

import Foundation

public typealias StatusCode = Int

public enum NetworkError: Error {
    
    /// - Client Error: 400...499
    case clientError(statusCode: StatusCode)
    
    /// - Server Error: 500...599
    case serverError(statusCode: StatusCode)
    
    /// - Parsing Error
    case parsingError(error: Error)
    
    /// - Request Error
    case requestError(errorMessage: String)
    
    /// - Other
    case other(statusCode: StatusCode?, error: Error?)
    
    
    static func handleStatusCodeError(_ statusCode: StatusCode) throws {
        
        switch statusCode {
        case 400...499:
            throw NetworkError.clientError(statusCode: statusCode)
            
        case 500...599:
            throw NetworkError.serverError(statusCode: statusCode)
            
        default:
            throw NetworkError.other(statusCode: statusCode, error: nil)
        }
    }
}

extension StatusCode {
    var isSuccess: Bool {
        (200..<300).contains(self)
    }
}
