//
//  EVWorker.swift
//  SwiftuiConcurrency
//
//  Created by hb on 09/01/25.
//

import Foundation

class EVWorker {
    
    func fetchChargeStations(request: EVModel.Request) async -> (EVModel.ViewModel?, Bool?, String?) {
        
        let dataService = NetworkService()
        let router = EVRouter.chargerFinderByCoordinates(request: request)
        
        do {
            let response: EVModel.ViewModel = try await dataService.generalDataRequest(with: router)
            return (response, response.status == "OK", response.status)
        } catch {
            return(nil, false, error.localizedDescription)
        }
    }
}
