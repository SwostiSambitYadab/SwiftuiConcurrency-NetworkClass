//
//  AsyncAwaitBootcamp.swift
//  SwiftuiConcurrency
//
//  Created by hb on 13/12/24.
//

import SwiftUI


class AsyncAwaitViewModel: ObservableObject {
    
    @Published var dataArray: [String] = []
    
    func addTitle() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dataArray.append("Title 1: \(Thread.current)")
        }
    }
    
    func addTitle2() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let title2 = "Title 2 : \(Thread.current)"
            DispatchQueue.main.async {
                self.dataArray.append(title2)
                
                let title3 = "Title 3 : \(Thread.current)"
                self.dataArray.append(title3)
            }
        }
    }
    
    
    func addAuthor() async {
        let author1 = "Author1 : \(Thread.current)"
        await MainActor.run {
            self.dataArray.append(author1)
        }
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        let author2 = "Author2 : \(Thread.current)"
        await MainActor.run {
            self.dataArray.append(author2)
            
            let author3 = "Author3: \(Thread.current)"
            self.dataArray.append(author3)
        }
    }
    
    func addSomething() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        let something1 = "something1 : \(Thread.current)"
        await MainActor.run {
            self.dataArray.append(something1)
            
            let something2 = "something2: \(Thread.current)"
            self.dataArray.append(something2)
        }
    }
    
}


struct AsyncAwaitBootcamp: View {
    
    @StateObject var vm = AsyncAwaitViewModel()
    
    var body: some View {
        List(vm.dataArray, id: \.self) { data in
            Text(data)
        }
        .onAppear {
            Task {
                await vm.addAuthor()
                await vm.addSomething()
                
                let finalText = "Final Text: \(Thread.current)"
                vm.dataArray.append(finalText)
            }
        }
    }
}

#Preview {
    AsyncAwaitBootcamp()
}
