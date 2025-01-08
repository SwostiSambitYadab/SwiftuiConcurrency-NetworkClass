//
//  StructClassActorBootCamp.swift
//  SwiftuiConcurrency
//
//  Created by hb on 16/12/24.
//

import SwiftUI

/**
 Links:
 https://blog.onewayfirst.com/ios/posts/2019-03-19-class-vs-struct/
 https://stackoverflow.com/questions/24217586/structure-vs-class-in-swift-language
 https://stackoverflow.com/questions/24217586/structure-vs-class-in-swift-language/59219141#59219141
 https://stackoverflow.com/questions/27441456/swift-stack-and-heap-understanding
 https://stackoverflow.com/questions/27441456/swift-stack-and-heap-understanding
 https://www.backblaze.com/blog/whats-the-diff-programs-processes-and-threads/
 
 
 VALUE TYPES:
 - Struct, Enum, String, Int etc.
 - Stored in the stack
 - Faster than the reference types
 - Thread safe by default
 - When you assign/pass a value type a new copy is created
 
 
 REFERENCE TYPES:
 - Class, Function, Actor
 - Stored in heap
 - Slower, but synchronized
 - Not thread safe(except actor)
 - When you assign or pass reference type a new reference to a original instance will be created (pointer)
 
 - - - - - - - - - - - - - - - - - -
 
 STACK:
 - Stored Value types
 - Variables allocated on the stack are stored directly to the memory, and access to this memory very fast
 - Each thread has it's own stack!
 
 
 HEAP:
 - Stores reference types
 - Shared across threads!
 
 
 - - - - - - - - - - - - - - - - - -
 
 STRUCT:
 - Based on VALUES
 - Can be mutated
 - Stored in the stack!
 
 
 CLASS:
 - Based of REFERENCES(INSTANCES)
 - Can't be mutated only the values can be updated
 - Stored in the heap!
 - Can inherit other classes
 
 ACTOR:
 - Same as class, but thread safe!
 
 
 - - - - - - - - - - - - - - - - -
 
 // normal use cases in swiftUI
 
 Structs: Data Models, Views
 
 Classes: ViewModels
 
 Actors: Shared `Manager` and `Data Store`
 
 */


/**
 Bonus point:
    - By marking an escaping closure block or any async code `weak self` we indicate to `ARC` that its alright to deallocate memory of the reference type and we don't want a strong reference, then if the use for example leaves from a screen in which we are executing that closure block or something else happens then `ARC` can have power to deallocate that memory .
 
 It typically happens in escaping closure blocks because it's need uncertain amount of time to execute, so if it's alright if we don't neccessarily need the data if the user leaves the screen then it is a good idea to mark that closure block as `weak self` .
 
 */


/**
    - Difference between class and struct is that class is reference type where as struct is value type
    - Classes changes the value of a parameter by accessing the reference and changing its value where as in structs when we update a value of its variables it creates a new struct entirely .
 */

/**
    - The main difference b/w a class and an actor is actor is a reference type with thread safety.
        ```
            i.e. when two different threads are accessing the same object from the heap memory , then one of them will await for the other thread to complete it's tasks first in an actor , hence making it thread safe and avoid race conditions.
        ```
 
    - To make it thread safe Actor-isolated property  can not be mutated from the main actor . So the properties can't be updated from outside the scope of the Actor .
 */


// can use actors in Managers as it can be used for different view models and possibly a race condition can occur .
actor StructClassActorManger {
    func fetchData()  {
    }
}

// can use classes in ViewModels as we need to syncronize the data in different views .
class StructClassActorViewModel: ObservableObject {
    @Published var isActive: Bool = false
    init() {
        debugPrint("ViewModel INIT")
    }
}

// Can use structs in views as we need faster responses and don't really need to store anyting in heap memory in the UI part
// and the things we want to store in heap can be stored using viewModels as they are typically reference type
struct StructClassActorBootCamp: View {
    
    @StateObject private var vm = StructClassActorViewModel()
    let isActive: Bool
    
    init(isActive: Bool) {
        self.isActive = isActive
        debugPrint("View INIT")
    }
    
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(isActive ? .red : .blue)
            .onAppear {
                // runTest()
            }
    }
}

#Preview {
    StructClassActorBootCamp(isActive: true)
}


struct StructClassActorHomeView: View {
    
    @State private var isActive: Bool = false
    
    var body: some View {
        StructClassActorBootCamp(isActive: isActive)
            .onTapGesture {
                isActive.toggle()
            }
    }
}

/**
 - `ARC` is the automatic reference count, whose job is to keep track and manage the app's memory usage. ARC automatically frees up the memory used by reference types when those instances are no loger needed .
    - It is only used in heap memory as reference types are stored in heap memeory to access from differenct threads .
    - ARC is not used in value types .
 */

extension StructClassActorBootCamp {
    
    private func runTest() {
        debugPrint("Test started")
        structTest1()
        printDivider()
        classTest1()
        printDivider()
        actorTest1()
        
//        structTest2()
//        printDivider()
//        classTest2()
    }
    
    
    private func structTest1() {
        let objA = MyStruct(title: "Starting Title!")
        print("ObjA: ", objA.title)
        
        
        print("Pass the value of objA to the value of objB")
        var objB = objA
        print("ObjB: ", objB.title)
        
        
        objB.title = "Second Title"
        print("ObjB title changed")
        
        print("ObjA: ", objA.title)
        print("ObjB: ", objB.title)
    }
    
    private func printDivider() {
        print(
            """

            - - - - - - - - - - -- -- -- -- -

            """
        )
    }
    
    private func classTest1() {
        let objA = MyClass(title: "Starting Title!")
        print("ObjA: ", objA.title)
        
        print("Pass the value of objA to the value of objB")
        let objB = objA
        print("ObjB: ", objB.title)

        
        objB.title = "Second Title"
        print("ObjB title changed")
        
        print("ObjA: ", objA.title)
        print("ObjB: ", objB.title)
    }
    
    
    private func actorTest1() {
        Task {
            let objA = MyActor(title: "Starting Title!")
            await print("ObjA: ", objA.title)
            
            print("Pass the value of objA to the value of objB")
            let objB = objA
            await print("ObjB: ", objB.title)
            
            
            await objB.updateTitle(newTitle: "Second Title")
            print("ObjB title changed")
            
            await print("ObjA: ", objA.title)
            await print("ObjB: ", objB.title)
        }
    }
}

struct MyStruct {
    var title: String
}

// Immutable struct
struct CustomStruct {
    let title: String
    
    func updateTitle(newTitle: String) -> CustomStruct {
        CustomStruct(title: newTitle)
    }
}

// what a mutating function does is, it changes the whole object so for structs to update values we use mutable functions
struct MutatingStruct {
    private(set) var title: String
    
    init(title: String) {
        self.title = title
    }
    
    mutating func updateTitle(newTitle: String) {
        title = newTitle
    }
}

extension StructClassActorBootCamp {
    
    private func structTest2() {
        print("Struct test 2")
        
        var struct1 = MyStruct(title: "Title1")
        print("Struct1: \(struct1.title)")
        
        struct1.title = "Title2"
        print("Strcut1: \(struct1.title)")
        
        var struct2 = CustomStruct(title: "Title1")
        print("Struct2: \(struct2.title)")
    
        struct2 = CustomStruct(title: "Title2")
        print("Struct2: \(struct2.title)")
        
        var struct3 = CustomStruct(title: "Title1")
        print("Struct3: \(struct3.title)")
        
        struct3 = struct3.updateTitle(newTitle: "Title2")
        print("Struct3: \(struct3.title)")
        
        
        var struct4 = MutatingStruct(title: "Title1")
        print("Struct4: \(struct4.title)")
        
        struct4.updateTitle(newTitle: "Title2")
        print("Struct4: \(struct4.title)")
    }
    
}

class MyClass {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String) {
        title = newTitle
    }
}

actor MyActor {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String) {
        title = newTitle
    }
}

extension StructClassActorBootCamp {
    
    private func classTest2() {
        print("Class test 2")
        
        let class1 = MyClass(title: "title1")
        print("Class1 : \(class1.title)")
        
        class1.title = "title2"
        print("Class1 : \(class1.title)")
        
        let class2 = MyClass(title: "title1")
        print("Class2 : \(class2.title)")
        
        class2.updateTitle(newTitle: "title2")
        print("Class2 : \(class2.title)")
        
    }
}
