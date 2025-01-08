//
//  TaskBootCamp.swift
//  SwiftuiConcurrency
//
//  Created by hb on 13/12/24.
//

import SwiftUI

/**
 For a long task i.e. suppose you are iterating over a loop and want to cancel a task then we can't just cancel the task from it's reference .
 
 - The task will be cancelled however the work that the task was doing still be working .
 ````
     for x in array {
        // work
     }
 ````
 - so , we need to check if the task is cancelled
 ```
     for x in array {
        // work
        
     try Task.checkCancellation()
        
     }
 ```
    - ``Task.checkCancellation()``  This will throw an error if the task is cancelled
*/




// MARK: - View model
class TaskBootCampViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil
    
    func fetchImage() async {
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        guard let url = URL(string: "https://picsum.photos/200") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            await MainActor.run {
                self.image = UIImage(data: data)
                debugPrint("Image returned successfully")
            }
        } catch {
            debugPrint("Error :: \(error.localizedDescription)")
        }
    }
    
    func fetchImage2() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        guard let url = URL(string: "https://picsum.photos/200") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            await MainActor.run {
                self.image2 = UIImage(data: data)
                debugPrint("Image returned successfully")
            }
        } catch {
            debugPrint("Error :: \(error.localizedDescription)")
        }
    }
}

// MARK: - View
struct TaskBootCamp: View {
    @StateObject private var vm = TaskBootCampViewModel()
    
    /**
    - When we use .`task modifier` we don't need to create a task variable and keep its reference and cancel it on view disappear .
     instead `iOS does it for us` when we use `.task modifer`
    */
    @State private var fetchImageTask: Task<(), Never>? = nil
     
    
    var body: some View {
        VStack(spacing: 40) {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .clipShape(.rect(cornerRadius: 10))
                    .shadow(radius: 10)
            }
            
            if let image = vm.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .clipShape(.rect(cornerRadius: 10))
                    .shadow(radius: 10)
            }
        }
        .task {
            await vm.fetchImage()
        }
        
        .task {
            await vm.fetchImage2()
        }
        
//        .onDisappear {
//            fetchImageTask?.cancel()
//        }
//        .onAppear {
//            fetchImageTask = Task {
//                await vm.fetchImage()
//            }
            
//            Task {
//                print(Thread.current)
//                print(Task.currentPriority)
//                await vm.fetchImage2()
//            }
            
            // Examples
            /*
//            Task(priority: .high) {
//                
//                // we can use yield to make way for other tasks to go ahead of the current task, it is more beneficial than using sleep
//                await Task.yield()
//                print("HIGH : \(Thread.current) : \(Task.currentPriority)")
//            }
//            
//            Task(priority: .userInitiated) {
//                print("USERINITIATED : \(Thread.current) : \(Task.currentPriority)")
//            }
//            
//            Task(priority: .medium) {
//                print("MEDIUM : \(Thread.current) : \(Task.currentPriority)")
//            }
//            
//            
//            Task(priority: .low) {
//                print("LOW : \(Thread.current) : \(Task.currentPriority)")
//            }
//            
//            Task(priority: .utility) {
//                print("UTILITY : \(Thread.current) : \(Task.currentPriority)")
//            }
//            
//            Task(priority: .background) {
//                print("BACKGROUND : \(Thread.current) : \(Task.currentPriority)")
//            }
            
//            Task(priority: .low) {
//                print("USERINITIATED : \(Thread.current) : \(Task.currentPriority)")
//                
//                Task {
//                    print("USERINITIATED2 : \(Thread.current) : \(Task.currentPriority)")
//                }
//            }
             */
//        }
    }
}


struct TaskBootCampHomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                NavigationLink {
                    TaskBootCamp()
                } label: {
                    Text("Click Me".uppercased())
                        .font(.headline)
                }
            }
        }
    }
}

#Preview {
    TaskBootCampHomeView()
}



#Preview {
    TaskBootCamp()
}
