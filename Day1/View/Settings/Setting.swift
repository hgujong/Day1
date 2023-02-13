//
//  Setting.swift
//  Day1
//
//  Created by 서종현 on 2023/02/02.
//

import SwiftUI
import CoreData

struct Setting: View {
    @ObservedObject var model: ViewModel
    @ObservedObject private var notiManager = NotificagtionManager()
    @State var todoNotification = false
    
    var body: some View {
        List {
            Section{
                HStack{
                    Toggle("알림 설정", isOn: $todoNotification)
                        .toggleStyle(SwitchToggleStyle(tint: Color("ThemeColor")))
                    
                }
            }
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            
            Text("Setting")
        }
    }
}

struct Setting_Previews: PreviewProvider {
    static var previews: some View {
        Setting(model: .init())
    }
}
