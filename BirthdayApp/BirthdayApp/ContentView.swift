//
//  ContentView.swift
//  BirthdayApp
//
//  Created by BumSu Park on 2022/05/31.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var viewModel: GoogleSignInModel
  
    
  var body: some View {
      let dateHolder = DateHolder()
      
    switch viewModel.state {
    case .signedIn: MainTabView()
                        .environmentObject(dateHolder)
      case .signedOut: LoginView()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
