//
//  Ring.swift
//  TaskApp
//
//  Created by junhyeok KANG on 2023/02/07.
//

import SwiftUI

struct Ring: Identifiable{
    var id = UUID().uuidString
    var progress: CGFloat
    var value: String
    var keyIcon: String
    var keyColor: Color
    var isText: Bool = false
} 

var rings: [Ring] = [
    
    Ring(progress: 72, value: "공부 시간", keyIcon: "pencil", keyColor: Color("Graph2")),
    Ring(progress: 91, value: "쉬는 시간", keyIcon: "😪", keyColor: Color("Graph1"), isText: true)
]
