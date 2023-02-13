//
//  LogBackground.swift
//  TaskApp
//
//  Created by junhyeok KANG on 2023/02/07.
//

import SwiftUI

struct LogBackground: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Log()
        } 
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background{
//            ZStack{
//                VStack{
//
//                }
//                Rectangle()
//                    .fill(.ultraThinMaterial)
//
//            }
//            .ignoresSafeArea()
//        }
    }
}

struct LogBackground_Previews: PreviewProvider {
    static var previews: some View {
        LogBackground()
    }
}
