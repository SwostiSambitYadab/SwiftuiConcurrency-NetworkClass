//
//  LoginRouter.swift
//  SwiftuiConcurrency
//
//  Created by hb on 08/01/25.
//

import Foundation

enum LoginRouter: RouterProtocol {
    
    case login(request: Login.Request)
    case categoryList

    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .categoryList:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "sign_in"
            
        case .categoryList:
            return "category_list"
        }
    }
    
    var requestType: RequestType {
        switch self {
        case .login:
            return .upload
        case .categoryList:
            return .data
        }
    }
    
    var parameters: RequestParameters? {
        
        var params: RequestParameters?
        
        switch self {
        case .login(let request):
            params = [
                "email": request.email,
                "password": request.password,
                "device_type": request.deviceType,
                "device_name": request.deviceName,
                "device_token": request.deviceToken,
                "app_version": request.appVersion,
                "device_os": request.deviceOS
            ]
            
        case .categoryList:
            params = nil
        }
        
        return params
    }
    
    var headers: RequestHeaders? {
        return ["Content-Type": "application/x-www-form-urlencoded"]
    }
    
    var files: [MultiPartData]? {
        return nil
    }
    
    var deviceInfo: RequestParameters? {
        return nil
    }
}
