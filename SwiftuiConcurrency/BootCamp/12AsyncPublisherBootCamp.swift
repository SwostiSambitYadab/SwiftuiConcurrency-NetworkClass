//
//  AsyncPublisherBootCamp.swift
//  SwiftuiConcurrency
//
//  Created by hb on 17/12/24.
//

import SwiftUI
import Combine


/**
 - We can't access published variables from actor in our viewmodels
 */

actor AsyncPublisherDataManager {
    @Published var myData: [String] = []
    
    func addData() async {
        myData.append("Apple")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        myData.append("Banana")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        myData.append("Orange")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        myData.append("Watermelon")
    }
}

class AsyncPublisherViewModel: ObservableObject {
    
    @MainActor @Published var dataArray: [String] = []
    private let manager = AsyncPublisherDataManager()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscriber()
    }
    
    func addSubscriber() {
        
        
        /**
         Value changes before the async publisher works howerver value changes after the async publisher doesn't work .
         
         If we want to use the changes after the async publisher we either need to break out of it or execute the task in another `Task`
         */
        
        // Using async publisher
        Task {
            
            await MainActor.run {
                self.dataArray = ["One"]
            }
            
            
            for await value in await manager.$myData.values {
                await MainActor.run {
                    self.dataArray = value
                }
            }
//            
//            await MainActor.run {
//                self.dataArray = ["Two"]
//            }
        }
        
        // using combine
        /*
        manager.$myData
            .receive(on: DispatchQueue.main)
            .sink { returnedArray in
                self.dataArray = returnedArray
            }
            .store(in: &cancellables)
        */
    }
    
    func start() async {
        await manager.addData()
    }
}

struct AsyncPublisherBootCamp: View {
    @StateObject private var vm = AsyncPublisherViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(vm.dataArray, id: \.self) { data in
                    Text(data)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .task {
            await vm.start()
        }
    }
}

#Preview {
    AsyncPublisherBootCamp()
}
