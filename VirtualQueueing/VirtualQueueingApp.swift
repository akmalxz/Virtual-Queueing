//
//  VirtualQueueingApp.swift
//  VirtualQueueing
//
//  Created by Akmal Hakim on 04/03/2023.
//

import SwiftUI
import Firebase

@main
struct VirtualQueueingApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}
