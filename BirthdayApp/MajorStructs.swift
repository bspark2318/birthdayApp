//
//  BirthdayStruct.swift
//  BirthdayApp
//
//  Created by BumSu Park on 2022/05/19.
//  https://stackoverflow.com/questions/53356392/how-to-get-day-and-month-from-date-type-swift-4

import Foundation

struct User: Hashable {
    var first_name: String
    var last_name: String
    var email: String
    var birthday: Date?
    var userID: String
    var profile_pic_url: URL?
    var profile_pic_thumbnail_url : URL?
}


struct Birthday: Hashable {
    var first_name: String
    var last_name: String
    var birthday: Date
    var importance: Importance
    var birthdayID: String
    var daysTill: Int
    var notificationEnabled: Bool
    var notifications: [String]
}


enum Importance: Int, CaseIterable
{
    case NotImportant = 0
    case Normal = 1
    case Important = 2
    var value: Int {self.rawValue}
}



extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
