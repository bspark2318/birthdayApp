//
//  BirthdayAppApp.swift
//  BirthdayApp
//
//  Created by BumSu Park on 2022/05/15.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
struct BirthdayAppApp: App {
    @StateObject var viewModel = GoogleSignInModel()
    
    init () {
        setUpAuthentication()
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
            
        }
    }
}

extension BirthdayAppApp {
    private func setUpAuthentication() {
        FirebaseApp.configure()
    }
}
