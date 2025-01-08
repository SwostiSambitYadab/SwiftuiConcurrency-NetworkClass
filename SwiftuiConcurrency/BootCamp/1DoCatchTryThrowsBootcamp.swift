//
//  DoCatchTryThrowsBootcamp.swift
//  SwiftuiConcurrency
//
//  Created by hb on 12/12/24.
//

import SwiftUI

class DoCatchTryThrowsDataManager {
    
    private let isActive: Bool = true
    
    // using tuple return type
    func fetchText1() -> (text: String?, error: Error?) {
        if isActive {
            return ("NEW TITLE", nil)
        } else {
            return (nil, URLError(.appTransportSecurityRequiresSecureConnection))
        }
    }
    
    // using result type
    func fetchText2() -> Result<String, Error> {
        if isActive {
            return .success("NEW TITLE")
        } else {
            return .failure(URLError(.timedOut))
        }
    }
    
    
    // using throw
    func fetchText3() throws -> String {
        if isActive {
            return "NEW TITLE"
        } else {
            throw(URLError(.backgroundSessionInUseByAnotherProcess))
        }
    }
    
    // using throw to return another string
    func fetchFinalText() throws -> String {
        if !isActive {
            return "Final Text"
        } else {
            throw(URLError(.badServerResponse))
        }
    }
}


class DoCatchTryThrowsViewModel: ObservableObject {
    @Published var text: String = "STARTING TITLE"
    private let manager = DoCatchTryThrowsDataManager()
    
    func getText() {
        
        // using tuple return type
        /*
        let result = manager.fetchText1()
        if let text = result.text {
            self.text = text
        } else {
            self.text = result.error?.localizedDescription ?? ""
        }
         */
        
        // using result
        /*
        let result = manager.fetchText2()
        
        switch result {
        case .success(let value):
            self.text = value
        case .failure(let error):
            self.text = error.localizedDescription
        }
        */
         
        // Using thorw statement
        
        /**
         - In do catch statements do statement will continue to execute unless gettina an error and then the catch block will be executed .
         */
        
        do {
            
            self.text = try manager.fetchText3()
            
            self.text = try manager.fetchFinalText()
            
        } catch {
            self.text = error.localizedDescription
        }
    }
}


struct DoCatchTryThrowsBootcamp: View {
    
    @StateObject var vm = DoCatchTryThrowsViewModel()
    
    var body: some View {
        Text(vm.text)
            .frame(width: 300, height: 300)
            .background(.red)
            .onTapGesture {
                vm.getText()
            }
    }
}

#Preview {
    DoCatchTryThrowsBootcamp()
}
