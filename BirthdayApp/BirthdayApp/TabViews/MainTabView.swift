//
//  MainTabView.swift
//  BirthdayApp
//
//  Created by BumSu Park on 2022/05/15.
//

import SwiftUI
import GoogleSignIn

struct MainTabView: View {
    
    @EnvironmentObject var dateHolder: DateHolder 
    @EnvironmentObject var viewModel: GoogleSignInModel
    
    // Referring to the user
    private let user = GIDSignIn.sharedInstance.currentUser
    
    var body: some View {
        
        
        TabView {
            
            SummaryView()
                .padding()
                .tabItem {
                    Image(systemName: "bell.fill")
                        .font(.largeTitle)
                        .padding()
                    Text("Upcoming")
                }
                .environmentObject(DataManager.sharedInstance)
            CalendarView()
                .environmentObject(dateHolder)
                .padding()
                .tabItem {
                    Image(systemName: "calendar")
                        .font(.largeTitle)
                        .padding()
                    Text("Calendar")
                }
            ProfileView(
                first_name: "",
                last_name: ""
            )
                .padding()
                .tabItem {
                    Image(systemName: "person.fill")
                        .font(.largeTitle)
                        .padding()
                    Text("Profile")
                }
        }
        .onAppear(){
            UITabBar.appearance().backgroundColor = .white
        }
        .accentColor(.birthdayColor)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
