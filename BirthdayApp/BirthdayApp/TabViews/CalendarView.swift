//
//  CalendarView.swift
//  BirthdayApp
//
//  Created by BumSu Park on 2022/05/15.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var dateHolder: DateHolder
    @State var showDetail = false
    @State var dataManager = DataManager.sharedInstance
    
    var body: some View {
        ZStack{
            
            VStack(spacing: 1) {
                DateScrollerView()
                    .environmentObject(dateHolder)
                    .padding()
                dayOfWeekStack
                calendarGrid
            }
            
        }
    }
    
    var dayOfWeekStack: some View {
        HStack(spacing: 1) {
            Text("Sun").dayOfWeek()
            Text("Mon").dayOfWeek()
            Text("Tue").dayOfWeek()
            Text("Wed").dayOfWeek()
            Text("Thu").dayOfWeek()
            Text("Fri").dayOfWeek()
            Text("Sat").dayOfWeek()
            
        }
    }
    
    var calendarGrid: some View
    {
        
        VStack(spacing: 1)
        {
            let daysInMonth = CalendarHelper().daysInMonth(dateHolder.date)
            let firstDayOfMonth = CalendarHelper().firstOfMonth(dateHolder.date)
            let startingSpaces = CalendarHelper().weekday(dateHolder.date)
            let previousMonth = CalendarHelper().minusMonth(dateHolder.date)
            let daysInPrevMonth = CalendarHelper().daysInMonth(previousMonth)
            
            ForEach(0..<6)
            {
                row in HStack(spacing: 1)
                {
                    ForEach(1..<8) {
                        column in
                        let count = column + (row * 7)
                        CalendarCell(count: count,
                                     startingSpaces: startingSpaces,
                                     daysInMonth: daysInMonth,
                                     daysInPreviousMonth: daysInPrevMonth)
                        .environmentObject(dateHolder)
                        
                        
                        
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}

extension Text{
    func dayOfWeek() -> some View {
        self.frame(maxWidth: .infinity)
            .padding(.top, 1)
            .lineLimit(1)
    }
}
