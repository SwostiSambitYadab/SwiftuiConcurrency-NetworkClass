//
//  MVVMBootCamp.swift
//  SwiftuiConcurrency
//
//  Created by hb on 17/12/24.
//

import SwiftUI

final class MyManagerClass {
    
    func getData() async throws -> String {
        "Some data"
    }
    
}

actor MyManagerActor {
    
    func getData() throws -> String {
        "Some data"
    }
}

@MainActor
final class MVVMViewModel: ObservableObject {
    
    let managerClass = MyManagerClass()
    let managerActor = MyManagerActor()
    
    private var tasks: [Task<Void, Never>] = []
    
    @Published private(set) var myData: String = "Starting text"
    
    
    func cancelTasks() {
        tasks.forEach { $0.cancel() }
        tasks = []
    }
    
    func onCallToActionButtonPressed() {
        let task = Task {
            do {
//                myData = try await managerClass.getData()
                myData = try await managerActor.getData()
            } catch {
                debugPrint("Error :: \(error.localizedDescription)")
            }
        }
        tasks.append(task)
    }
}


struct MVVMBootCamp: View {
    
    @StateObject private var vm = MVVMViewModel()
    
    
    var body: some View {
        VStack {
            Button(vm.myData) {
                vm.onCallToActionButtonPressed()
            }
        }
        .onDisappear {
            vm.cancelTasks()
        }
    }
}

#Preview {
    MVVMBootCamp()
}
