//
//  ObservableBootCamp.swift
//  SwiftuiConcurrency
//
//  Created by hb on 18/12/24.
//

import SwiftUI

/**
 • The `Obseravable macro` replaced `ObservableObject`.
 
 • We `don't` need to add `@Published` property wrapper as it will publish values by default for the properties.
 
 • We now need to explicitly tell the compiler when using Observable macro for the properties we don't want to publish by marking them with a property wrapper `@ObservationIgnored`.
 
 • We `don't` need to create `@StateObject` to handle use ObservableViewModels as we don't conform to Observable Object any more. So the `new norm` is to use `@State` property wrapper.
 
 • Similarly, `@ObservedObject` changed to `@Bindable` .
 
 • And `@EnvironmentObject` changed to `@Environment` .
 
 • Similarly we will use `.environment` instead of `.environmentObject` to pass observable objects through the environment
    
 
 /// - how to migrate observable object protocol to @Observable
 ```
 ObservableObject protocol  -> @Observable
 
 @Published var             -> var
 
 var                        -> @ObservationIgnored var
 
 @StateObject               -> @State
 
 @ObservedObject            -> @Bindable
 
 @EnvironmentObject         -> @Environment(Object.self)
 
 .environmentObject(value)  -> .environment(value)
 
 ```
 */

@Observable
class ObservableLearningViewModel {
    var title: String = "Some title"
    @ObservationIgnored var value: String = "Some title"
    
}

 struct ObservableLearningBootCamp: View {
     
     @State private var vm = ObservableLearningViewModel()
     
    var body: some View {
        
        VStack(spacing: 30) {
            Button(vm.title) {
                vm.title = "New title!"
            }
            
            SomeChildView(vm: vm)
            
            SomeThirdView()
        }
        .environment(vm)
    }
}

#Preview {
    ObservableLearningBootCamp()
}


struct SomeChildView: View {
    
    @Bindable var vm = ObservableLearningViewModel()
    
    var body: some View {
        Button(vm.title) {
            vm.title = "Child New title!"
        }
    }
}

struct SomeThirdView: View {
    
    @Environment(ObservableLearningViewModel.self) var vm: ObservableLearningViewModel
    
    var body: some View {
        Button(vm.title) {
            vm.title = "Third New title!"
        }
    }
}
