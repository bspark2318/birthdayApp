//
//  ProfileView.swift
//  BirthdayApp
//
//  Created by BumSu Park on 2022/05/16.
//
// https://www.youtube.com/watch?v=M_yhOR9KkgQ&ab_channel=Kavsoft
import SwiftUI
import GoogleSignIn

struct ProfileView: View {
    
    @State var showDetail = false
    @State private var image = UIImage()
    @State private var showSheet = false
    @State var first_name: String
    @State var last_name: String
    @State var birthday: Date = Date()
    
    
    let dateFormatter = DateFormatter()
    
    var body: some View {
        ZStack {
            ZStack {
                
                if image != UIImage() {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .cornerRadius(30)
                } else {
                    AsyncImage(url: DataManager.sharedInstance.user.profile_pic_url ) {
                        image in
                        image
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)
                            .cornerRadius(30)
                        
                    } placeholder: {
                        Image("profile")
                            .resizable()
                            .scaledToFit()
                            .edgesIgnoringSafeArea(.all)
                            .cornerRadius(30)
                    }
                    
                }
                
                
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white.opacity(0.85))
                        .frame(width: 120, height: 30)
                        .padding(30)
                    Button(action: {
                        
                        self.showDetail.toggle()
                        
                    }) {
                        Text("Edit Profile")
                            .foregroundColor(.birthdayColor)
                        
                    }
                    .sheet(isPresented: $showDetail) {
                        
                        
                        ProfileEditView(
                            isPresented: $showDetail,
                            first_name: $first_name,
                            last_name: $last_name,
                            email: DataManager.sharedInstance.user.email,
                            profile_pic_url: DataManager.sharedInstance.user.profile_pic_url ?? nil,
                            profile_pic_thumbnail_url :  DataManager.sharedInstance.user.profile_pic_thumbnail_url ?? nil,
                            birthday: $birthday,
                            userID: DataManager.sharedInstance.user.userID)
                    }
                }
                .offset(x: UIScreen.main.bounds.size.width/13 * 4 ,
                        y: UIScreen.main.bounds.size.height/14 * -5)
                
                ZStack{
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white.opacity(0.85))
                        .frame(width: 120, height: 30)
                        .padding(30)
                    Button(action: {
                        self.showSheet.toggle()
                    }) {
                        Text("Change Pic")
                            .foregroundColor(.birthdayColor)
                        
                    }
                    .sheet(isPresented: $showSheet) {
                        ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
                    }
                }
                .offset(x: UIScreen.main.bounds.size.width/13 * -4 ,
                        y: UIScreen.main.bounds.size.height/14 * -5)
                
                VStack{
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.white.opacity(0.85))
                            .frame(width: UIScreen.main.bounds.size.width - 40, height: 90)
                            .padding(30)
                        
                        
                        VStack(alignment: .leading){
                            Text("**User: \(first_name == "" ? DataManager.sharedInstance.user.first_name : first_name) \(last_name == "" ? DataManager.sharedInstance.user.last_name : last_name)**")
                                .font(.title3)
                                .frame(maxWidth: .infinity,
                                       alignment: .leading)
                            Spacer()
                                .frame(height:5)
                
                            
                            
                            if Calendar.current.isDateInThisMonth(birthday) {
                                
                                if DataManager.sharedInstance.user.birthday != nil {
                                    let date = returnDate(date: DataManager.sharedInstance.user.birthday!)
                                    Text("**Birthday: \(date)**")
                                        .font(.title3)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                } else {
                                    Text("**Birthday: Unknown**")
                                        .font(.title3)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            } else {
                                
                                    let date = returnDate(date: birthday)
                                    Text("**Birthday: \(date)**")
                                        .font(.title3)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                            
                            }
                            
                            
                            
                            
                            
                            
                            
                        }
                        .frame(width: UIScreen.main.bounds.size.width - 80, height: 90)
                    }
                }
                .zIndex(1)
                Spacer()
            }
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

struct BottomShape : Shape {
    
    func path(in rect: CGRect) -> Path {
        return Path{ path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
        }
    }
}

struct BlurView : UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialLight))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<BlurView>) {
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(
            first_name: "Name", last_name: "Fake", birthday: Date()
        )
    }
}


