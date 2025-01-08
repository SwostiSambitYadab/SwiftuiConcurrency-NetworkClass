//
//  CategoryView.swift
//  SwiftuiConcurrency
//
//  Created by hb on 07/01/25.
//

import SwiftUI

struct CategoryView: View {
    
    @State private var categories: [CategoryListModel] = []
    
    var body: some View {
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
                .foregroundStyle(.white)
                .background(.blue)
                .cornerRadius(8)
            }
        }
        .task {
            await fetchCategoryList()
        }
    }
    
    
    private func fetchCategoryList() async {
        let worker = LoginWorker()
        let (categoryList, success, message) = await worker.doFetchCategoryListAPI()
        if let categoryList, success == true  {
            categories = categoryList
        }
        debugPrint("Potential Error / success message :: \(message ?? "")")
    }
}

#Preview {
    CategoryView()
}
