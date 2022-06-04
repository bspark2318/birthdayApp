//
//  LoginPage.swift
//  BirthdayApp
//
//  Created by BumSu Park on 2022/05/31.
//

import SwiftUI
import GoogleSignInSwift

struct LoginView: View {

  
  @EnvironmentObject var viewModel: GoogleSignInModel

  var body: some View {
    VStack {
      Spacer()

  
      Image("cake")
        .resizable()
        .aspectRatio(contentMode: .fit)

      Text("Welcome to Birthday App!")
        .fontWeight(.black)
        .foregroundColor(Color(Color.cakeColor.cgColor!))
        .font(.largeTitle)
        .multilineTextAlignment(.center)

      Text("Birthday tracking made simple.")
        .fontWeight(.light)
        .multilineTextAlignment(.center)
        .padding()

      Spacer()

      
      GoogleSignInButton()
        .padding()
        .onTapGesture {
          viewModel.signIn()
        }
    }
  }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
