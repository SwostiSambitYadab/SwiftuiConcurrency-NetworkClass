//
//  GlobalActorsBootCamp.swift
//  SwiftuiConcurrency
//
//  Created by hb on 16/12/24.
//

import SwiftUI

/**
 • Global actors are the shared instance in which we can make other non-isolated methods isolated to that global actor .
 */


@globalActor final class MyFirstGlobalActor {
    static var shared = MyNewDataManager()
}

actor MyNewDataManager {
    func getDataFromDB() -> [String] {
        return ["One", "Two", "Three", "Four", "Five", "Six", "Seven"]
    }
}

@MainActor
class GlobalActorBootCampViewModel: ObservableObject {
    
    @Published var dataArray: [String] = []
    @Published var dataArray1: [String] = []
    @Published var dataArray2: [String] = []
    @Published var dataArray3: [String] = []
    @Published var dataArray4: [String] = []
    @Published var dataArray5: [String] = []
    @Published var dataArray6: [String] = []
    @Published var dataArray7: [String] = []
    @Published var dataArray8: [String] = []
    
    let manager = MyFirstGlobalActor.shared
    
    @MyFirstGlobalActor
     func getData() async {
        
        // HEAVY COMPLEX METHODS
        let data = await manager.getDataFromDB()
         await MainActor.run {
             self.dataArray = data
         }
    }
}


struct GlobalActorsBootCamp: View {
    
    @StateObject private var vm = GlobalActorBootCampViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(vm.dataArray, id: \.self) {
                    Text($0)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .task {
            await vm.getData()
        }
    }
}

#Preview {
    GlobalActorsBootCamp()
}
