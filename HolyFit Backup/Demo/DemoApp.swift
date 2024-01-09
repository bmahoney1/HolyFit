//
//  DemoApp.swift
//  Demo
//
//  Created by Brennan Mahoney on 5/18/23.
//

import SwiftUI
import Firebase

@main
struct DemoApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
