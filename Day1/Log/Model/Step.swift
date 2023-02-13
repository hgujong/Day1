//
//  Step.swift
//  TaskApp
//
//  Created by junhyeok KANG on 2023/02/07.
//

import SwiftUI

struct Step: Identifiable{
    var id = UUID().uuidString
    var value: CGFloat
    var key: String
    var color: Color = Color("Graph2")
} 

var step: [Step] = [
    Step(value: 500, key: "1-4 AM"),
    Step(value: 240, key: "5-8 AM", color:  Color("Graph1")),
    Step(value: 350, key: "9-11 AM"),
    Step(value: 500, key: "1-4 PM"),
]
