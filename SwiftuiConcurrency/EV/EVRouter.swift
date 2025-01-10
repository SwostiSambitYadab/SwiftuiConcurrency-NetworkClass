//
//  EVRouter.swift
//  SwiftuiConcurrency
//
//  Created by hb on 09/01/25.
//

import Foundation

enum EVRouter: RouterProtocol {
    
    case chargerFinderByCoordinates(request: EVModel.Request)
    
    
    var baseUrlString: String {
        return "https://ev-charge-finder.p.rapidapi.com/"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "search-by-coordinates-point"
    }
    
    var parameters: RequestParameters? {
        var params: RequestParameters?
        
        switch self {
        case .chargerFinderByCoordinates(let request):
            params = [
                "lat": request.lat,
                "lng": request.lng
            ]
        }
        return params
    }
    
    var headers: RequestHeaders? {
        return [
            HTTPHeaderField.rapidKey.rawValue: AppConstatns.rapidAPIKey,
            HTTPHeaderField.rapidHost.rawValue: AppConstatns.rapidAPIHost
        ]
    }
    
    var requestType: RequestType {
        return .data
    }
    
    var files: [MultiPartData]? {
        return nil
    }
    
    var deviceInfo: RequestParameters? {
        return nil
    }
}


enum HTTPHeaderField: String {
    case acceptType = "Accept"
    case contentType = "Content-Type"
    case authentication = "Authorization"
    case acceptEncoding = "Accept-Encoding"
    
    case rapidKey = "x-rapidapi-key"
    case rapidHost = "x-rapidapi-host"
}
