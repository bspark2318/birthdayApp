//
//  CalendarCell.swift
//  BirthdayApp
//
//  Created by BumSu Park on 2022/05/15.
//

import SwiftUI

struct CalendarCell: View {
    let count: Int
    let startingSpaces: Int
    let daysInMonth: Int
    let daysInPreviousMonth: Int
    @State var showDetail = false
    @State var birthdays : [Birthday] = []

    
    var body: some View {
        VStack{
            HStack{
                
                Text(monthStruct().day())
                    .foregroundColor(textColor(type: monthStruct().monthType))
                    .frame(maxWidth: .infinity)
//                    .border(.blue)
                    .gesture(
                        TapGesture()
                            .onEnded {
                                print(String(count))
                            }
                    )
            }
            VStack(spacing: 0) {
                ForEach(birthdays, id: \.self) {birthday in
                    
                        switch birthday.importance {
                        case .NotImportant:
                            Text(" \(birthday.first_name)")
                                .lineLimit(1)
                                .font(.system(size: 12))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.gray)
                        case .Normal:
                            Text(" \(birthday.first_name)")
                                .lineLimit(1)
                                .font(.system(size: 12))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        default: // Important
                            
                            Text(" \(birthday.first_name)")
                                .lineLimit(1)
                                .font(.system(size: 12))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .border(.white)
                                .padding([.leading, .trailing], 0.5)
                                .cornerRadius(10)
                                .gesture(
                                    TapGesture()
                                        .onEnded {
                                            self.showDetail.toggle()
                                        }
                                )
                                .sheet(isPresented: $showDetail) {
                                   
                                    
                                    CalendarBirthdayEditView(
                                        isPresented: $showDetail,
                                        create: false,
                                        first_name: birthday.first_name, last_name: birthday.last_name,
                                        birthday: birthday.birthday, 
                                        month: birthday.birthday.get(.month),
                                        day: birthday.birthday.get(.day),
                                        birthdayID: birthday.birthdayID,
                                        notificationEnabled: birthday.notificationEnabled,
                                        selections: birthday.notifications,
                                        selectedImportanceIndex: birthday.importance.value
                                    )
                                }
                            
                            
                            
                            
                            
                            
                            
                        }
                    }
                
            }
            
            Spacer()
        }
        
        
        
        //        }
        
    }
    
    func textColor(type: MonthType) -> Color {
        return type == MonthType.Current ? Color.black : Color.gray
    }
    
    func monthStruct() -> MonthStruct {
        let start = startingSpaces == 0 ? startingSpaces + 7 : startingSpaces
        if (count <= start) {
            let day = daysInPreviousMonth + count - start
            return MonthStruct(monthType: MonthType.Previous, dayInt: day)
        }
        else if (count - start > daysInMonth)
        {
            let day = count - start - daysInMonth
            return MonthStruct(monthType: MonthType.Next, dayInt: day)
        }
        
        let day = count - start
        return MonthStruct(monthType: MonthType.Current, dayInt: day)
    }
}

struct CalendarCell_Previews: PreviewProvider {
    static var previews: some View {
        CalendarCell(count: 1, startingSpaces: 1, daysInMonth: 1, daysInPreviousMonth: 1)
    }
}
