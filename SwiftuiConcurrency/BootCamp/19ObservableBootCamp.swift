//
//  ObservableBootCamp.swift
//  SwiftuiConcurrency
//
//  Created by hb on 18/12/24.
//

import SwiftUI

/**
 - When using the `@Observable` macro we don't get the `purple warning` for publishing changes other than the main thread like we used to get for `ObservableObject` .
 
 - So we might face some issues, performance and worse crashes without us knowing that we had to update the code in the main thread .
 
 - For that we can use `@MainActor` macro in `published variables` and `functions`.
 
 - I am not sure yet but I think if we mark the `whole class` with `@MainActor` it still works .
 
 - Or we can use `await @MainActor.run` method to switch back to main thread when updating properties linked to UI .
 */


actor TitleDatabase {
    func getNewTitle() -> String {
        return "Some new title"
    }
}

//@MainActor
@Observable final class ObservableViewModel {
    
    @MainActor private(set) var title: String = "Starting title"
    @ObservationIgnored private let manager = TitleDatabase()
    
    @MainActor
    func updateTitle() async {
//        await MainActor.run {
            title = await manager.getNewTitle()
//        }
    }
}


struct ObservableBootCamp: View {
    
    @State private var vm = ObservableViewModel()
    
    var body: some View {
        Text(vm.title)
            .task {
                await vm.updateTitle()
            }
    }
}

#Preview {
    ObservableBootCamp()
}
