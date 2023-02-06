//
//  DateButton.swift
//  Day1
//
//  Created by 서종현 on 2023/02/02.
//

import SwiftUI

struct DateButton: View {
    var title : String
    @ObservedObject var model : ViewModel
    var body: some View {
        
        Button(action: {model.updateDate(value: title)}, label: {
            
            Text(title)
                .fontWeight(.bold)
                .foregroundColor(model.checkDate() == title ? .white : .gray )
                .padding(.vertical,10)
                .padding(.horizontal,20)
                .background(
                    model.checkDate() == title ?
                    LinearGradient(gradient: .init(colors: [Color.indigo,Color.blue]), startPoint: .leading, endPoint: .trailing)
                    :LinearGradient(gradient: .init(colors: [Color.white]), startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(8)
        })
    }
}
