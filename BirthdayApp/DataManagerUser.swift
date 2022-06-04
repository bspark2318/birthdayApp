//
//  DataManagerUser.swift
//  BirthdayApp
//
//  Created by BumSu Park on 2022/06/03.
//

import Foundation
import GoogleSignIn


extension DataManager {
    
    func createUser(_ user: GIDGoogleUser) {
        
        let first_name = user.profile?.givenName ?? "Unknown"
        let last_name = user.profile?.familyName ?? "Unknown"
        let userEmail = user.profile?.email ?? "Unknown"
        let userID = user.userID ?? "Unknown"
        
        let userData = UserData(first_name: first_name,
                                last_name: last_name,
                                birthday: "Unknown",
                                email: userEmail,
                                profile_pic_url: nil,
                                profile_pic_thumbnail_url: nil,
                                userID: userID)
        
        var jsonData = Data()
        do {
            jsonData = try JSONEncoder().encode(userData)
        }
        catch {
            print("Error while encoding data to JSON format")
        }
        
        
        guard let endpointUrl = URL(string: apiEndpoint + "api/create_user") else {
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
            
            self.user = User(first_name: userData.first_name,
                             last_name: userData.last_name,
                             email: userData.email,
                             birthday: userData.birthday != "Unknown" ? userData.birthday.iso8601withFractionalSeconds : nil,
                             userID: userData.userID)
            
        })
        
        task.resume()
    }
    
    
    func retrieveUser(_ user: GIDGoogleUser) {
        
        let userID = user.userID ?? "Unknown"
        
        guard let endpointUrl = URL(string: apiEndpoint + "api/retrieve_user") else {
            return
        }
        
        var request = URLRequest(url: endpointUrl)
        request.setValue(userID, forHTTPHeaderField: "UserID")
        request.setValue(api_key, forHTTPHeaderField: "X-Api-Key")
        
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
            
            if let data = data {
                do {
                    let userData = try JSONDecoder().decode(UserData.self, from: data)
                    let user = User(first_name: userData.first_name,
                                    last_name: userData.last_name,
                                    email: userData.email,
                                    birthday: userData.birthday.iso8601withFractionalSeconds,
                                    userID: userData.userID,
                                    profile_pic_url: userData.profile_pic_url ?? nil,
                                    profile_pic_thumbnail_url: userData.profile_pic_thumbnail_url ?? nil
                    )
                    self.user = user
                    
                    print("Where is the user ")
                    print(self.user)
                } catch let decoderError {
                    print(decoderError)
                }
                
            }
            
            
        })
        task.resume()
    }
    
    func updateUser(_ userData: UserData) {
        
        var jsonData = Data()
        do {
            jsonData = try JSONEncoder().encode(userData)
        }
        catch {
            print("Error while encoding data to JSON format")
        }
        
        
        guard let endpointUrl = URL(string: apiEndpoint + "api/update_user") else {
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
                print("Error while making an API call to /api/update_user endpoint")
                
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(response)")
                return
            }
            
            self.user = User(first_name: userData.first_name,
                             last_name: userData.last_name,
                             email: userData.email,
                             birthday: userData.birthday != "Unknown" ? userData.birthday.iso8601withFractionalSeconds : nil,
                             userID: userData.userID)
            
        })
        
        task.resume()
        
    }
    
    
    func uploadPhoto(_ photoData: PhotoData) {
        
        var jsonData = Data()
        do {
            jsonData = try JSONEncoder().encode(photoData)
        }
        catch {
            print("Error while encoding data to JSON format")
        }
        
        
        guard let endpointUrl = URL(string: apiEndpoint + "api/upload_photo") else {
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
                print("Error while making an API call to /api/update_user endpoint")
                
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(response)")
                return
            }
            
            if let data = data {
                do {
                    let userData = try JSONDecoder().decode(UserData.self, from: data)
                    let user = User(first_name: userData.first_name,
                                    last_name: userData.last_name,
                                    email: userData.email,
                                    birthday: userData.birthday.iso8601withFractionalSeconds,
                                    userID: userData.userID,
                                    profile_pic_url: userData.profile_pic_url,
                                    profile_pic_thumbnail_url: userData.profile_pic_thumbnail_url
                    )
                    self.user = user
                } catch let decoderError {
                    print(decoderError)
                }
                
            }

            
        })
        
        task.resume()
        
    }
    
    
    //func getUserBirthdays() {
    //
    //    guard let endpointUrl = URL(string: apiEndpoint + "api/get_birthdays") else {
    //        return
    //    }
    //
    //    var request = URLRequest(url: endpointUrl)
    //
    //    guard let userID = GIDSignIn.sharedInstance.currentUser?.userID else {
    //        print("Error while retrieving current user")
    //        return
    //    }
    //
    //    request.setValue(userID, forHTTPHeaderField: "UserID")
    //    request.setValue(api_key, forHTTPHeaderField: "X-Api-Key")
    //
    //    let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
    //
    //        if let error = error {
    //            print("Error while making an API call to /api/get_birthdays endpoint")
    //            return
    //        }
    //
    //        guard let httpResponse = response as? HTTPURLResponse,
    //              (200...299).contains(httpResponse.statusCode) else {
    //            print("Error with the response, unexpected status code: \(response)")
    //            return
    //        }
    //
    //        if let data = data {
    //            do {
    //                let birthdays = try JSONDecoder().decode([BirthdayData].self, from: data)
    //                self.initializeBirthdays(birthdays)
    //            } catch let decoderError {
    //                print(decoderError)
    //            }
    //
    //        }
    //    })
    //
    //    task.resume()
    //
    //}
    //
    
    
    
}
