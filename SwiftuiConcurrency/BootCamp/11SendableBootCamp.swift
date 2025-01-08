//
//  SendableBootCamp.swift
//  SwiftuiConcurrency
//
//  Created by hb on 16/12/24.
//

import SwiftUI

/**
 The Sendable protocol indicate that value of the given type can be safely used in concurrent code.
 
 these are typically value types
 
 - We can only pass sendable objects to an actor.
 If we were to pass a class in the actor then we have to make that class a final class i.e. other classes can't inherit from it and the properties should be constants otherwise the compiler will throw a warning sign `Stored property 'isActive' of 'Sendable'-conforming class 'MyUserInfo' is mutable`
 
 - If we still want to use a variable inside a sendable protocol then we have to mark the protocol as `@unchecked Sendable` which literally means the compiler will not check for any non-sendable values inside the class , which is super dangerous.
 beacause we have to make sure that the class is sendable manually by using custom queues or locks.
 
 - For structs we don't need to add Sendable protocol because structs are by default Sendable; but there is some slight performance benefits just by confirming the structs to Sendable and then passing it to the actor
 */

actor CurrUserManager {
    
    func updateDB(userInfo: MyUserInfo) {
        
    }
}

struct MyStructInfo: Sendable {
    let name: String
}

/**
 - Manually making the class thread safe using variables and unchecked sendable protocol
 */
final class MyUserInfo: @unchecked Sendable {
    private(set) var name: String
    private let queue = DispatchQueue(label: "com.myApp.concurrency")
    
    init(name: String) {
        self.name = name
    }
    
    func updateName(name: String) {
        queue.async {
            self.name = name
        }
    }
}

class SendableViewModel: ObservableObject {
    let manager = CurrUserManager()
    
    func updateCurrUserInfo() async {
        let info = MyUserInfo(name: "user info")
        await manager.updateDB(userInfo: info)
    }
}


struct SendableBootCamp: View {
    
    @StateObject private var vm = SendableViewModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .task {
                await vm.updateCurrUserInfo()
            }
    }
}

#Preview {
    SendableBootCamp()
}
