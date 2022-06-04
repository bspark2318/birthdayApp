//
//  ProfileEditView.swift
//  BirthdayApp
//
//  Created by BumSu Park on 2022/06/03.
//

import SwiftUI
import GoogleSignIn

struct ProfileEditView: View {
    @Binding var isPresented: Bool
    private let user = GIDSignIn.sharedInstance.currentUser
    let importanceChoices: [Importance] = [.NotImportant, .Normal, .Important]
    @Binding var first_name: String
    @Binding var last_name: String
    @State var email: String
    @State var profile_pic_url: URL?
    @State var profile_pic_thumbnail_url : URL?
    @Binding var birthday: Date
    @State var userID: String
    
    var body: some View {
        Form {
            Section(header: Text("User INFO")) {
                HStack {
                    Text("First Name")
                        .frame(width: 120, alignment: .leading)
                    TextField("\(first_name)", text: $first_name)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                }
                HStack {
                    Text("Last Name")
                        .frame(width: 120, alignment: .leading)
                    TextField("\(last_name)", text: $last_name)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                }
                
                HStack {
                    DatePicker(
                        "Birthday Date",
                        selection: $birthday,
                        displayedComponents: [.date]
                    )
                    .multilineTextAlignment(.leading)
                    .fixedSize()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            
            Section {
                Button(action: {
                    let userData = UserData(
                        first_name: first_name,
                        last_name: last_name,
                        birthday: birthday.iso8601withFractionalSeconds,
                        email: email,
                        profile_pic_url: profile_pic_url,
                        profile_pic_thumbnail_url: profile_pic_thumbnail_url,
                        userID: userID)
                    DataManager.sharedInstance.updateUser(userData)
                    isPresented = false
        
                }) {
                    Text("Edit")
                        .font(.title3)
                        .foregroundColor(.red)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                }
            }
            
        }
        
    }
}

struct ProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditView(
            isPresented: .constant(false),
            first_name: .constant("Yirang"),
            last_name: .constant("Park"),
                        email: "",
            birthday: .constant(Date()),
                        userID: "Hello")
    }
}
