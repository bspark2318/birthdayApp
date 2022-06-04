//
//  SummaryView.swift
//  BirthdayApp
//
//  Created by BumSu Park on 2022/05/16.


// Sourced from https://www.youtube.com/watch?v=MPIdZHMZd3E&ab_channel=Kavsoft
import SwiftUI

struct SummaryView : View {
    @State var offset: CGPoint = .zero
    @State var showDetail = false
    @EnvironmentObject var dataManager: DataManager
    let dateFormatter = DateFormatter()
    
    var body: some View {
        NavigationView {
            
            ZStack {
                
                Image(systemName: "plus")
                    .frame(width: 45, height: 45)
                    .foregroundColor(Color.birthdayColor)
                    .background(Color.white)
                    .clipShape(Circle())
                    .overlay(Circle()       .stroke(lineWidth: 3).foregroundColor(Color.birthdayColor))
                    .offset(x: UIScreen.main.bounds.size.width/13 * 4,
                            y: UIScreen.main.bounds.size.height/13 * 4)
                    .onTapGesture {
                        self.showDetail.toggle()
                    }
                    .sheet(isPresented: $showDetail) {
                        CalendarBirthdayEditView(
                            isPresented: $showDetail,
                                        create: true,
                                                 first_name: "",
                                                 last_name: "",
                                                 birthday: Date(),
                                                 month: 5,
                                                 day: 12,
                                                 birthdayID: "",
                                                 notificationEnabled: true,
                                                 selections: [],
                                                 selectedImportanceIndex: 1)
                    }
                    .zIndex(1)
                
                BirthdayScrollView(offset: $offset, showIndicators: true, axis: .vertical, content: {
                    ZStack {
                        VStack(spacing: 15) {
                            ForEach( dataManager.birthdays , id:\.self) {birthday in
                                NavigationLink  {
                                    
                                    CalendarBirthdayEditView(
                                        isPresented: $showDetail,
                                        create: false,
                                        first_name: birthday.first_name,
                                        last_name: birthday.last_name,
                                        birthday: birthday.birthday,
                                        month: birthday.birthday.get(.month),
                                        day: birthday.birthday.get(.day),
                                        birthdayID: birthday.birthdayID,
                                        notificationEnabled: birthday.notificationEnabled,
                                        selections: birthday.notifications,
                                        selectedImportanceIndex: birthday.importance.value)
                                } label:  {
                                    
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(.white)
                                            .frame(height: 75)
                                            .padding([.leading, .trailing])
                                            .shadow(radius: 5)
                                        
                                        HStack(spacing: 15) {
                                            
                                            Image("cake")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 55, height: 55)
                                                .clipShape(Circle())
                                                .overlay(Circle().stroke(Color.orange, lineWidth: 3))
                                                .padding(.leading)
                                            
                                            VStack(alignment: .leading, spacing: 10, content: {
                                                Text(birthday.first_name + " " + birthday.last_name )
                                                    .fontWeight(.bold)
                                                    .font(.title2)
                                                    .frame(height:15)
                                                
                                                
                                                Text("\(returnDate(date: birthday.birthday)) - In \(birthday.daysTill) days")
                                                    .font(.subheadline)
                                                    .frame(height:15)
                                                    .padding(.trailing, 10)
                                                
                                            })
                                            Spacer()
                                        }
                                        .padding(.horizontal)
                                    }
                                    .foregroundColor(.black)
                                }
                                
                                
                            }
                        }
                        .padding(.top)
                    }
                    
                })
                
            }
            
            .navigationTitle("Birthdays")
        }
    }
    
    func returnDate(date: Date) -> String {
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        let date = dateFormatter.string(from: date)
    
        return date
    }
    
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
    }
}

struct BirthdayScrollView<Content: View>: View {
    
    var content: Content
    @Binding var offset: CGPoint
    var showIndicators: Bool
    var axis: Axis.Set
    
    init(offset: Binding<CGPoint>, showIndicators: Bool, axis: Axis.Set, @ViewBuilder content: ()-> Content) {
        
        self.content = content()
        self._offset = offset
        self.showIndicators = showIndicators
        self.axis = axis
    }
    
    var body: some View {
        ScrollView(axis, showsIndicators: showIndicators, content: {
            content
        })
    }
    
}
