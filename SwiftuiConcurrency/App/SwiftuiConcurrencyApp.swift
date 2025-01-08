//
//  SwiftuiConcurrencyApp.swift
//  SwiftuiConcurrency
//
//  Created by hb on 12/12/24.
//

import SwiftUI

@main
struct SwiftuiConcurrencyApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        NetworkMonitor.shared.startMonitoring()
        
        return true
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        NetworkMonitor.shared.stopMonitoring()
    }
    
}
