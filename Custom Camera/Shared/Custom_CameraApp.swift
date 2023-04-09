//
//  Custom_CameraApp.swift
//  Shared
//
//  Created by Balaji on 12/12/20.
//

import SwiftUI
import Firebase

@main
struct Custom_CameraApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    init(){
        FirebaseApp.configure()
    }
}
