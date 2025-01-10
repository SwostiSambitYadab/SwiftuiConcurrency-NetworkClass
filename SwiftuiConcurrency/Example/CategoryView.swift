//
//  CategoryView.swift
//  SwiftuiConcurrency
//
//  Created by hb on 07/01/25.
//

import SwiftUI

struct CategoryView: View {
    
    @State private var categories: [CategoryListModel] = []
    let worker = LoginWorker()
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(categories, id: \.categoryId) { category in
                    
                    VStack {
                        Text(category.category ?? "")
                            .font(.headline)
                        
                        Text(category.categoryId ?? "")
                            .font(.headline)
                            .bold()
                    }
                    .padding(24)
                    .foregroundStyle(.green)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .shadow(radius: 2)
                    )
                }
            }
        }
        .scrollIndicators(.hidden)
        .task {
//            await fetchCategoryList()
//            await tryToLogin()
            await fetchEVDetails()
        }
    }
    
    
    private func fetchCategoryList() async {
        let (categoryList, success, message) = await worker.doFetchCategoryListAPI()
        
        debugPrint("CATEGORYLIST: \(categoryList ?? [])")
        debugPrint("SUCCESS: \(success ?? false)")
        debugPrint("MESSAGE: \(message ?? "")")
        
        
        if let categoryList, success == true  {
            categories = categoryList
        }
        debugPrint("Potential Error / success message :: \(message ?? "")")
    }
    
    private func tryToLogin() async {
        
        let request = Login.Request(
            email: "john@yopmail.com",
            password: "John@123"
        )
        
        
        let (loginResponse, success, message) = await worker.callLoginAPI(request: request)
        
        debugPrint("LOGIN RESPONSE: \(String(describing: loginResponse))")
        debugPrint("SUCCESS: \(success ?? false)")
        debugPrint("MESSAGE: \(message ?? "")")
        
    }
    
    private func fetchEVDetails() async {
        let worker = EVWorker()
        let request = EVModel.Request(
            lat: 23.0225,
            lng: 72.5714
        )
        
        let (evResponse, success, message) = await worker.fetchChargeStations(request: request)
        debugPrint("EVRESPONSE: ", evResponse)
        debugPrint("SUCCESS: \(success ?? false)")
        debugPrint("MESSAGE: \(message ?? "")")
    }
}

#Preview {
    CategoryView()
}
