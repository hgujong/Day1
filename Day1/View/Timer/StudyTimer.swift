//
//  StudyTimer.swift
//  Day1
//
//  Created by junhyeok KANG on 2023/02/13.
//

import SwiftUI

struct StudyTimer: View {
    @ObservedObject var model: ViewModel
    var body: some View {
        VStack(spacing: 20){
            HStack(spacing:10){
                Text("Study Timer")
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .background{
                        RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(gradient: Gradient(colors: [Color("ThemeColor"), Color("Purple")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 180)
                        
                    }
                    .frame(alignment: .leading)
            }
        }
            
    }
}

struct StudyTimer_Previews: PreviewProvider {
    static var previews: some View {
        StudyTimer(model: .init())
    }
}
