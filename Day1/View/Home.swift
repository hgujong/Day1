//
//  Home.swift
//  Day1
//
//  Created by 서종현 on 2023/02/02.
//

import SwiftUI

struct Home: View {
    @StateObject var model = ViewModel()
    
    
    var body: some View {
        TabView {
            Memo(model: model)
                .tabItem {
                    Label("Todo", systemImage: "checklist")
                }
            StopW(model: model)
                .tabItem{
                    Label("StopWatch", systemImage: "stopwatch")
                }
            StudyTimer(model: model)
                .tabItem{
                    Label("Timer", systemImage: "timer")
                }
            
            Analysis(model: model)
                .tabItem {
                    Label("Analyis", systemImage: "chart.bar.xaxis")
                }
            
            Setting(model: model)
                .tabItem {
                    Label("Setting", systemImage: "gear")
                }
        }
        .accentColor(Color("ThemeColor"))
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
