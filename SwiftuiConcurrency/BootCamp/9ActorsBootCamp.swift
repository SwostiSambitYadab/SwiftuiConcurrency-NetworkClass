//
//  ActorsBootCamp.swift
//  SwiftuiConcurrency
//
//  Created by hb on 16/12/24.
//

import SwiftUI

// 1. What is the problem actors are solving? -> Data Race

// 2. How was this problem solved prior to actors? -> By using manual queue/lock

// 3. How actors solve this problems? -> iOS made it thread safe by default



/**
 - Prior to actor we use a manual queue/lock to make classes thread safe
 */
final class MyDataManager {
    
    static let instance = MyDataManager()
    private init() {}
    
    var data: [String] = []
    private let queue = DispatchQueue(label: "com.swiftUI.mydataManager")
    
    
    func getRandomData(completion: @escaping(_ returnedTitle: String?) -> Void) {
        queue.async {
            self.data.append(UUID().uuidString)
            debugPrint("Thread :: \(Thread.current)")
            completion(self.data.randomElement())
        }
    }
}

/**
 - We can use `non-isolated` inside actors to make the properties or methods available outside the async await block .
    However we can't access ioslated values in a non-isolated function to maintain Thread safety.
 */
actor MyActorDataManager {
    static let instance = MyActorDataManager()
    private init() {}
    
    nonisolated let startingText = "Starting Text"
    var data: [String] = []

    
    func getRandomData() -> String? {
        self.data.append(UUID().uuidString)
        debugPrint("Thread :: \(Thread.current)")
        return self.data.randomElement()
    }
    
    
    nonisolated func getSavedData() -> String {
        return "NEW DATA"
    }
}



struct ActorsBootCamp: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
    }
}


struct HomeView: View {
        
    @State private var text: String = ""
    
    private let manager = MyActorDataManager.instance
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.8)
                .ignoresSafeArea()
            
            Text(text)
                .font(.headline)
        }
        .onReceive(timer) { _ in
            
            Task {
                if let data = await manager.getRandomData() {
                    await MainActor.run {
                        self.text = data
                    }
                }
            }
            
            // Prior to Actor
            /*
            DispatchQueue.global(qos: .background).async {
                manager.getRandomData { returnedTitle in
                    if let data = returnedTitle {
                        DispatchQueue.main.async {
                            self.text = data
                        }
                    }
                }
            }
             */
        }
        .onAppear {
            debugPrint(manager.getSavedData())
        }
    }
}

struct SearchView: View {
    
    @State private var text: String = ""
    
    private let manager = MyActorDataManager.instance
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.yellow.opacity(0.8)
                .ignoresSafeArea()
            
            Text(text)
                .font(.headline)
        }
        .onReceive(timer) { _ in
            
            Task {
                if let data = await manager.getRandomData() {
                    await MainActor.run {
                        self.text = data
                    }
                }
            }
            // Prior to actor
            /*
            DispatchQueue.global(qos: .default).async {
                manager.getRandomData { returnedTitle in
                    if let data = returnedTitle {
                        DispatchQueue.main.async {
                            self.text = data
                        }
                    }
                }
            }
             */
        }
    }
}


#Preview {
    ActorsBootCamp()
}
