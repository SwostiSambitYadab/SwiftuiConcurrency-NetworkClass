//
//  StrongSelfBootCamp.swift
//  SwiftuiConcurrency
//
//  Created by hb on 17/12/24.
//

import SwiftUI


actor StrongSelfDataService {
    
    func getData() -> String {
        return "Updated data"
    }
    
}

final class StrongSelfViewModel: ObservableObject {
    @Published var data: String = "Some title"
    let dataService = StrongSelfDataService()
    
    private var someTask: Task<Void, Never>? = nil
    private var myTasks: [Task<Void, Never>] = []
    
    
    func cancelTasks() {
        someTask?.cancel()
        someTask = nil
        myTasks.forEach { $0.cancel() }
    }
    

    /// - This implies a strong reference...
    func updateData() {
        Task {
            data = await dataService.getData()
        }
    }
    
    /// - This implies a strong reference...
    func updateData2() {
        Task {
            self.data = await dataService.getData()
        }
    }
    
    /// - This implies a strong reference...
    func updateData3() {
        Task { [self] in
            self.data = await dataService.getData()
        }
    }
    
    /// - This implies a weak reference...
    func updateData4() {
        Task { [weak self] in
            if let data = await self?.dataService.getData() {
                self?.data = data
            }
        }
    }
    
    /// - We don't need to manage weak strong reference,
    /// as we can manage the tasks
    func updateData5() {
        someTask = Task {
            self.data = await dataService.getData()
        }
    }
    
    
    func updateData6() {
        let task1 = Task {
            self.data = await dataService.getData()
        }
        
        let task2 = Task {
            self.data = await dataService.getData()
        }
        
        myTasks.append(task1)
        myTasks.append(task2)
    }
    
    /// - Purposely do not cancel tasks to keep strong reference..
    func updateData7() {
        Task {
            self.data = await dataService.getData()
        }
        
        Task.detached {
            self.data = await self.dataService.getData()
        }
    }
    
    /// - when using the task modifier it cancels the tasks automatically so we don't need to manage it myself
    func updateData8() async {
        self.data = await self.dataService.getData()
    }
}


struct StrongSelfBootCamp: View {
    
    @StateObject private var vm = StrongSelfViewModel()
    
    var body: some View {
        Text(vm.data)
            .font(.headline)
            .onAppear {
                vm.updateData()
            }
            .onDisappear {
                vm.cancelTasks()
            }
            .task {
                await vm.updateData8()
            }
    }
}

#Preview {
    StrongSelfBootCamp()
}
