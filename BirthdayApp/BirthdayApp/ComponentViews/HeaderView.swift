//
//  HeaderView.swift
//  BirthdayApp
//
//  Created by BumSu Park on 2022/05/15.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        
        GeometryReader { geometry in
            Ellipse()
                .fill(Color.red)
                .frame(width: geometry.size.width * 1.6,
                       height: geometry.size.height*0.23,
                       alignment: .top)
                .position(x: geometry.size.width / 2,
                          y: geometry.size.height*0.075)
                .shadow(radius: 3)
                .edgesIgnoringSafeArea(.all)
            Text("Hello World")
                .position(x: geometry.size.width / 2,
                          y: geometry.size.height * 0.05)
            
            
        }
        
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
