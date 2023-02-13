//
//  ContentView.swift
//  Day1
//
//  Created by 서종현 on 2023/02/02.
//

import SwiftUI
import CoreData

struct ContentView: View {
     
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    var body: some View {
       Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
