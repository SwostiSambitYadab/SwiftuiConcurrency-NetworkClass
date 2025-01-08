//
//  LoginWorker.swift
//  SwiftuiConcurrency
//
//  Created by hb on 07/01/25.
//

import Foundation

class LoginWorker {
    
    func doFetchCategoryListAPI() async -> ([CategoryListModel]?, Bool?, String?) {
     
        let dataService = NetworkService()
        let router = LoginRouter.categoryList
        
        do {
            let response: WSResponse<CategoryListModel> = try await dataService.dataRequest(with: router)
            
            if let dictData = response.dictData, let success = response.setting?.isSuccess, let message = response.setting?.message {
                return ([dictData], success, message)
            } else if let arrayData = response.arrayData,arrayData.count > 0, let success = response.setting?.isSuccess, let message = response.setting?.message {
                return (arrayData, success, message)
            } else {
                return (nil, response.setting?.isSuccess, response.setting?.message)
            }
        } catch {
            return (nil, false, error.localizedDescription)
        }
    }
}


enum Login {
    // MARK: Use cases
    struct Request {
        var email: String
        var password: String
    }
    
    class ViewModel: WSResponseData {

        var accessToken : String?
        var email : String?
        var fullName : String?
        var loginType : String?
        var profilePic : String?
        var role : String?
        var userId : Int?
        var username : String?

        override init() {
            super.init()
        }
        private enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case email = "email"
            case fullName = "full_name"
            case loginType = "login_type"
            case profilePic = "profile_pic"
            case role = "role"
            case userId = "user_id"
            case username = "username"
        }
        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(accessToken, forKey: .accessToken)
            try container.encode(email, forKey: .email)
            try container.encode(fullName, forKey: .fullName)
            try container.encode(loginType, forKey: .loginType)
            try container.encode(profilePic, forKey: .profilePic)
            try container.encode(role, forKey: .role)
            try container.encode(userId, forKey: .userId)
            try container.encode(username, forKey: .username)
        }
        required public init(from decoder: Decoder) throws {
            try super.init(from: decoder)
            let values = try decoder.container(keyedBy: CodingKeys.self)
            accessToken = try values.decodeIfPresent(String.self, forKey: .accessToken)
            email = try values.decodeIfPresent(String.self, forKey: .email)
            fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
            loginType = try values.decodeIfPresent(String.self, forKey: .loginType)
            profilePic = try values.decodeIfPresent(String.self, forKey: .profilePic)
            role = try values.decodeIfPresent(String.self, forKey: .role)
            userId = try values.decodeIfPresent(Int.self, forKey: .userId)
            username = try values.decodeIfPresent(String.self, forKey: .username)
        }
    }
}


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
            return "login"
            
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
                "password": request.password
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



class CategoryListModel: WSResponseData {
    var category : String?
    var categoryId : String?
    var categoryImage : String?
    
    override init() {
        super.init()
    }
    
    private enum CodingKeys: String, CodingKey {
        case category = "category"
        case categoryId = "category_id"
        case categoryImage = "category_image"
    }
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(category, forKey: .category)
        try container.encode(categoryId, forKey: .categoryId)
        try container.encode(categoryImage, forKey: .categoryImage)
    }
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        category = try values.decodeIfPresent(String.self, forKey: .category)
        categoryId = try values.decodeIfPresent(String.self, forKey: .categoryId)
        categoryImage = try values.decodeIfPresent(String.self, forKey: .categoryImage)
    }
}
