//
//  AsyncStreamBootCamp.swift
//  SwiftuiConcurrency
//
//  Created by hb on 17/12/24.
//

import SwiftUI

/**
 • `Async Streams` are used to convert `non-async (asyncronous code without async await) `to `async(code with async await)`.
 
 • If a completion handler is returning values only once then we use `CheckedContinuation`; where as if the completion handler is executing multiple times then we use `Async Streams`
 
 • Like CheckedContinuation there are 2 types of Async Streams
    - AsyncStream<Any>
    - AsyncThrowingStream<Any, Any Error>
 
 • Like the name suggests `Async Throwing Stream` throws errors if found .
 
 */


final class AsyncStreamDataManager {
    
    func getAsyncStream() -> AsyncStream<Int> {
        AsyncStream { [weak self] continuation in
            self?.getFakeData { value in
                continuation.yield(value)
            } onFinish: { error in
                continuation.finish()
            }
        }
    }
    
    
    func getAsyncThrowingStream() -> AsyncThrowingStream<Int, Error> {
        
        AsyncThrowingStream { [weak self] continuation in
            self?.getFakeData { value in
                continuation.yield(value)
            } onFinish: { error in
                continuation.finish(throwing: error)
            }
        }
    }
    
    
    func getFakeData(newValue: @escaping(_ value: Int) -> Void, onFinish: @escaping(_ error : Error?) -> Void) {
        
        let items: [Int] = [1, 2, 3, 4 , 5, 6, 7, 8, 9, 10]
        
        for item in items {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(item)) {
                
                debugPrint("NEW DATA :: \(item)")
                
                newValue(item)
                
                if item == items.last {
                    onFinish(nil)
                }
            }
        }
    }
}


@MainActor
final class AsyncStreamViewModel: ObservableObject {
    @Published private(set) var currentNumber: Int = 0
    let manager = AsyncStreamDataManager()
    
    
    func onViewAppear() {
        
        /// - Using completion handler `(before)`
        /*
        manager.getFakeData { [weak self] value in
            self?.currentNumber = value
        }
        */
        
        /// - Using `Async Stream`
        /*
        Task {
            let stream = manager.getAsyncStream()
            for await value in stream {
                currentNumber = value
            }
        }
        */
        
        /// - Using `Async Throwing Stream`
        let task = Task {
            do {
                for try await value in manager.getAsyncThrowingStream().dropFirst(2) {
                    currentNumber = value
                }
            } catch {
                debugPrint("Error :: \(error)")
            }
        }
        
        
        /// - when we cancel the task its not gonna cancel the underlying method, so we need to handle it from code level ourselves
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//            task.cancel()
//            debugPrint("Cancelled")
//        }
    }
}


struct AsyncStreamBootCamp: View {
    
    @StateObject private var vm = AsyncStreamViewModel()
    
    var body: some View {
        Text("\(vm.currentNumber)")
            .font(.headline)
            .onAppear {
                vm.onViewAppear()
            }
    }
}

#Preview {
    AsyncStreamBootCamp()
}
