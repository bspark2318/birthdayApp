//
//  CaledarBirthdayEditView.swift
//  BirthdayApp
//
//  Created by BumSu Park on 2022/05/19.
//

import SwiftUI
import GoogleSignIn

struct CalendarBirthdayEditView: View {
    
    @Binding var isPresented: Bool
    private let user = GIDSignIn.sharedInstance.currentUser
    let importanceChoices: [Importance] = [.NotImportant, .Normal, .Important]
    @State private var selectedChoice = 0
    @State var create: Bool
    @State var first_name: String
    @State var last_name: String
    @State var birthday: Date
    @State var month: Int
    @State var day: Int
    @State var birthdayID: String
    @State var notificationEnabled: Bool
    @State var selections: [String]
    @State var selectedImportanceIndex: Int
    let importanceSettings = ["Casual", "Important", "Critical"]
    let notificationSettings = ["On the Day Of",
                                "1 Day Before",
                                "3 Days Before",
                                "A Week Before",
                                "Two Weeks Before",
                                "A Month Before",
                                "Two Months Before"]

    
    
    
    var body: some View {
        Form {
            Section(header: Text("BIRTHDAY INFO")) {
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
                
                HStack {
                    Text("Importance")
                        .frame(width: 120, alignment: .leading)
                    
                    Picker("", selection: $selectedImportanceIndex) {
                        ForEach(0..<importanceSettings.count) { index in
                            Text(importanceSettings[index])
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .multilineTextAlignment(.trailing)
                }
                
            }
            
            
            Section {
            Button(action: {
                guard let userID = user?.userID else{
                    print("Error: User not defined")
                    return
                }
                
                let bdayID = self.create ? UUID().uuidString : self.birthdayID
                
                
                
                
                let birthdayData = BirthdayData(first_name: self.first_name,
                                              last_name: self.last_name,
                                              birthday: self.birthday.iso8601withFractionalSeconds,
                                                importance: self.selectedImportanceIndex,
                                            owner: userID,
                                              birthdayID: bdayID,
                                              notificationEnabled: self.notificationEnabled,
                                                notifications: self.selections.joined(separator: ",")
                )
                
                if self.create {
                    DataManager.sharedInstance.addNewBirthday(birthdayData)
                    isPresented = false
                } else {
                    DataManager.sharedInstance.updateBirthday(birthdayData)
                }
            }) {
                if self.create {
                    Text("Submit")
                        .font(.title3)
                        .foregroundColor(.green)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                } else {
                    Text("Update")
                        .font(.title3)
                        .foregroundColor(.green)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                }
            }
            }
            
            if !self.create {
                Button(action: {
                    guard let userID = self.user!.userID else {
                        
                        return
                    }
                    
                    DataManager.sharedInstance.deleteBirthday(self.birthdayID, ownerID: userID)
                }) {
                    Text("Delete")
                        .font(.title3)
                        .foregroundColor(.red)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                }
            }
            
        }
        
    }
    
    
}

struct CalendarBirthdayEditView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarBirthdayEditView(
            isPresented: .constant(false),
            create: false,
            first_name: "h", last_name: "h", birthday: Date(), month: 1, day: 1, birthdayID: "", notificationEnabled: true, selections: [""], selectedImportanceIndex: 1)
    }
}

