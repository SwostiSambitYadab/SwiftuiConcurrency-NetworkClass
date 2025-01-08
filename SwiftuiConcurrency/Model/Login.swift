//
//  Login.swift
//  SwiftuiConcurrency
//
//  Created by hb on 08/01/25.
//

import Foundation
import UIKit

enum Login {
    // MARK: Use cases
    struct Request {
        var email: String
        var password: String
        var appVersion: String = "1.0.8"
        var deviceType: String = "iOS"
        var deviceName: String = UIDevice.current.name
        var deviceToken: String = UUID().uuidString
        var deviceOS: String = UIDevice.current.systemVersion
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
