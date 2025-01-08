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
    
    
    func callLoginAPI(request: Login.Request) async -> (Login.ViewModel?, Bool?, String?) {
        
        let dataService = NetworkService()
        let router = LoginRouter.login(request: request)
        
        do {
            
            let response: WSResponse<Login.ViewModel> = try await dataService.dataRequest(with: router)
            
            if let dictData = response.dictData, let success = response.setting?.isSuccess, let message = response.setting?.message {
                return(dictData, success, message)
            } else if let arrayData = response.arrayData, arrayData.count > 0, let success = response.setting?.isSuccess, let message = response.setting?.message {
                return(arrayData[0], success, message)
            } else {
                return(nil, response.setting?.isSuccess, response.setting?.message)
            }
        } catch {
            return (nil, false, error.localizedDescription)
        }
    }
}
