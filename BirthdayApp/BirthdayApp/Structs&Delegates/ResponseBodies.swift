//
//  ResponseBodies.swift
//  BirthdayApp
//
//  Created by BumSu Park on 2022/06/02.
//

import Foundation

// Codable structs

struct BirthdayData: Codable {
    let first_name: String
    let last_name: String
    let birthday: String
    let importance: Int
    let owner: String
    let birthdayID: String
    let notificationEnabled: Bool
    let notifications: String
}


struct UserData: Codable {
    let first_name: String
    let last_name: String
    let birthday: String
    let email: String
    let profile_pic_url: URL?
    let profile_pic_thumbnail_url: URL?
    let userID: String
}

struct PhotoData: Codable {
    let userID: String
    let photo: String 
}
