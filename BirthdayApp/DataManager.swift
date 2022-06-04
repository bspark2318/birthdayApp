//
//  DataManager.swift
//  BirthdayApp
//
//  Created by BumSu Park on 2022/06/01.
//  https://www.freecodecamp.org/news/how-to-make-your-first-api-call-in-swift/

import Foundation
import GoogleSignIn

public class DataManager: ObservableObject {
    
    
    // MARK: - Singleton Stuff
    public static let sharedInstance = DataManager()
    
    // For storage
    let defaults = UserDefaults.standard
    let api_key = "abcdef123456"
    let apiEndpoint = "https://birthday-app-352106.uc.r.appspot.com/"
    @Published var birthdays : [Birthday] = []
    @Published var user : User = User(first_name: "",
                                      last_name: "",
                                      email: "",
                                      birthday: nil,
                                      userID: "",
                                      profile_pic_url: nil,
                                      profile_pic_thumbnail_url: nil)
    
    
    
    //This prevents others from using the default '()' initializer
    fileprivate init() {
    }
    
    
    func daysBetween(target: Date) -> Int {
        // Specify date components
        var dateComponents = DateComponents()
        var today = Date()
        
        if (target.get(.month) > today.get(.month)) {
            dateComponents.year = today.get(.year)
        } else if (target.get(.month) == today.get(.month)) {
            if target.get(.day) >= today.get(.day) {
                dateComponents.year = today.get(.year)
            } else {
                dateComponents.year = today.get(.year) + 1
            }
        } else {
            dateComponents.year = today.get(.year) + 1
        }
        
        dateComponents.month = target.get(.month)
        dateComponents.day = target.get(.day)
        
        
        // Create date from components
        let userCalendar = Calendar(identifier: .gregorian)
        
        let targetDate = userCalendar.date(from: dateComponents)!
        return Calendar.current.dateComponents([.day], from: today, to: targetDate).day! + 1
        
    }
    
    
    func convertBirthday(_ birthday: BirthdayData) -> Birthday {
        
        var importance : Importance
        switch(birthday.importance) {
        case 1:
            importance = .Normal
        case 2:
            importance = .Important
        default:
            importance = .NotImportant
        }
        
        
        let daysTill = daysBetween(target: birthday.birthday.iso8601withFractionalSeconds!)
        print("Converting")
        let subStrings = birthday.notifications.split(separator: ",")
        print(subStrings)
        var notifications : [String] = []
        for sub in subStrings{
            notifications.append(String(sub))
        }
        print(notifications)
        print("notifications")
        let entry = Birthday(
            
            first_name: birthday.first_name,
            last_name: birthday.last_name,
            birthday: birthday.birthday.iso8601withFractionalSeconds!,
            importance: importance,
            birthdayID: birthday.birthdayID,
            daysTill: daysTill,
            notificationEnabled: birthday.notificationEnabled,
            notifications: notifications
        )
        return entry
    }
    
    func sortBirthdays() {
        self.birthdays.sort { (lhs: Birthday, rhs: Birthday) -> Bool in
            // you can have additional code here
            return lhs.daysTill < rhs.daysTill
        }
    }
    
    func initializeBirthdays(_ birthdays: [BirthdayData]) {
        self.birthdays = []
        var i = 0
        for birthday in birthdays {
            let entry = self.convertBirthday(birthday)
            self.birthdays.append(entry)
        }
        self.sortBirthdays()
    }
    
    
    func getUserBirthdays() {
        
        guard let endpointUrl = URL(string: apiEndpoint + "api/get_birthdays") else {
            return
        }
        
        var request = URLRequest(url: endpointUrl)
        
        guard let userID = GIDSignIn.sharedInstance.currentUser?.userID else {
            print("Error while retrieving current user")
            return
        }
        
        request.setValue(userID, forHTTPHeaderField: "UserID")
        request.setValue(api_key, forHTTPHeaderField: "X-Api-Key")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if let error = error {
                print("Error while making an API call to /api/get_birthdays endpoint")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(response)")
                return
            }
            
            if let data = data {
                do {
                    let birthdays = try JSONDecoder().decode([BirthdayData].self, from: data)
                    self.initializeBirthdays(birthdays)
                } catch let decoderError {
                    print(decoderError)
                }
                
            }
        })
        
        task.resume()
        
    }
    
    //    func addNewBirthday(completionHandler: @escaping ([Film]) -> Void) {
    func addNewBirthday(_ birthdayData: BirthdayData) {
        var jsonData = Data()
        do {
            jsonData = try JSONEncoder().encode(birthdayData)
        }
        catch {
            print("Error while encoding data to JSON format")
        }
        
        
        guard let endpointUrl = URL(string: apiEndpoint + "api/add_birthday") else {
            return
        }
        
        var request = URLRequest(url: endpointUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(api_key, forHTTPHeaderField: "X-Api-Key")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            // your code here
            if let error = error {
                print("Error while making an API call to /api/add_birthday endpoint")
                
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(response)")
                return
            }
            
            let birthday = self.convertBirthday(birthdayData)
            self.birthdays.append(birthday)
            self.sortBirthdays()
            
        })
        
        task.resume()
    }
    
    func removeBirthday(_ birthdayID: String) {
        if let index = self.birthdays.index(where: { $0.birthdayID == birthdayID }) {
            self.birthdays.remove(at: index)
        }
    }
    
    func updateBirthday(_ birthdayData: BirthdayData) {
        var jsonData = Data()
        do {
            jsonData = try JSONEncoder().encode(birthdayData)
        }
        catch {
            print("Error while encoding data to JSON format")
        }
        
        
        guard let endpointUrl = URL(string: apiEndpoint + "api/update_birthday") else {
            return
        }
        
        var request = URLRequest(url: endpointUrl)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(api_key, forHTTPHeaderField: "X-Api-Key")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            // your code here
            if let error = error {
                print("Error while making an API call to /api/update_birthday endpoint")
                
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(response)")
                return
            }
            
            
            let birthday = self.convertBirthday(birthdayData)
            self.removeBirthday(birthday.birthdayID)
            self.birthdays.append(birthday)
            self.sortBirthdays()
            
        })
        
        task.resume()
        
    }
    
    func deleteBirthday(_ birthdayID: String, ownerID: String) {
        
        guard let endpointUrl = URL(string: apiEndpoint + "api/delete_birthday") else {
            return
        }
        
        var request = URLRequest(url: endpointUrl)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(api_key, forHTTPHeaderField: "X-Api-Key")
        request.setValue(birthdayID, forHTTPHeaderField: "birthdayID")
        request.setValue(ownerID, forHTTPHeaderField: "userID")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            // your code here
            if let error = error {
                print("Error while making an API call to /api/delete_birthday endpoint")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(response)")
                return
            }
            
            self.removeBirthday(birthdayID)
            
        })
        
        task.resume()
        
    }
    
    
    
    
}
