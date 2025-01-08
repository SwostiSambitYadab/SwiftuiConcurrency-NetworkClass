//
//  RefreshableBootCamp.swift
//  SwiftuiConcurrency
//
//  Created by hb on 17/12/24.
//

import SwiftUI


actor RefreshableDataService {
    func getData() async throws -> [String] {
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        return ["Apple", "Banana", "Orange", "Watermelon"].shuffled()
    }
}


@MainActor
final class RefreshableViewModel: ObservableObject {
    
    @Published private(set) var items: [String] = []
    let service = RefreshableDataService()
    
    func loadData() async {
        do {
            items = try await service.getData()
        } catch {
            debugPrint(error.localizedDescription)
            
        }
    }
}


struct RefreshableBootCamp: View {
    
    @StateObject private var vm = RefreshableViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(vm.items, id: \.self) { item in
                        Text(item)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .refreshable {
                await vm.loadData()
            }
            .navigationTitle("Refreshable")
            .task {
                await vm.loadData()
            }
        }
    }
}

#Preview {
    RefreshableBootCamp()
}
