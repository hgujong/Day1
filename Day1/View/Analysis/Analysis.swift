//
//  Analysis.swift
//  Day1
//
//  Created by junhyeok KANG on 2023/02/13.
//


// 지금 문제는 Todo가 하나 만들어질 때마다
// ring이 계속 만들어짐 이걸 하나로 만들 방법 생각할 것

import SwiftUI

struct Analysis: View {
    @ObservedObject var model: ViewModel
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                HStack(alignment: .top, spacing: 8){
                    Text("Analysis")
                        .font(.title.bold())
                        .foregroundColor(Color("ThemeColor"))
                    
                    Spacer()
                    //공부 목표 시간,쉬는 시간 편집
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.title3)
                    })
                }
                .foregroundColor(.blue)
                
                HStack(spacing: 10){
                    // MARK: 상단 날짜 버튼
                    ForEach(model.currentweek, id: \.self) { day in
                        
                        VStack(spacing: 10) {
                            
                            //날짜
                            Text(model.extractDate(date: day, format: model.isToday(date: day) ? "MM.dd EEE" : "dd"))
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                            
                            Circle()
                                .fill(.white)
                                .frame(width: 8, height: 8)
                                .opacity(model.isToday(date: day) ? 1 : 0)
                            
                        }
                        .foregroundStyle(model.isToday(date: day) ? .primary : .secondary)
                        .foregroundColor(model.isToday(date: day) ? .white : .gray)
                        .frame(width: model.isToday(date: day) ? 120 : 30, height: 40)
                        .background(
                            
                            ZStack{
                                // MARK: Matched Geometry Effect
                                if model.isToday(date: day) {
                                    Capsule()
                                        .fill(Color("ThemeColor"))
                                }
                            }
                        )
                        .contentShape(Capsule())
                        .onTapGesture {
                            // Updating current Day
                            withAnimation {
                                model.currentDay = day
                            }
                        }
                        
                    }
                }
                
                TaskView()
                
                //MARK: 한주 요약
                
            }
            .padding()
        }
        
    }
    
    // MARK: TaskView
    @ViewBuilder
    func TaskView()-> some View {
        LazyVStack(spacing: 20) {
//            ForEach(tasks){ task in
//                TaskRowView(task: task)
//            }
            AnalysisDynamicFilteredView(model: model, currentTab: model.currentTab) { (task: Task) in
                TaskRowView(task: task)
            }
        }
        .padding(.top, 20)
    }
    
    // MARK: Task Row View
    @ViewBuilder
    func TaskRowView(task: Task)-> some View {

        
        // MARK: 해당일 공부시간, 쉬는 시간 링 그래프
        
        VStack(alignment: .leading, spacing: 8){
            Text("금일 학습시간")
                .font(.title2)
                .fontWeight(.semibold)
            Text("\(Int(model.studyTime / 3600 ))시간 \(Int(model.studyTime / 60 ))분")
                .font(.system(size: 45, weight: .bold))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical,10)
        
        VStack(spacing: 15){
            
            Text("Progress")
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack(spacing: 20){
                ZStack{
                    // study time
                    AnimatedRingView(model: model, showRing: false,index: 1,color: Color(.blue))
                    // break time
                    AnimatedRingViewB(model: model, showRing: false,index: 2,color: Color(.red))
                }
                .frame(width: 130, height: 130)
                
                VStack(alignment: .leading,spacing: 12){
                    Label{
                        HStack(alignment: .bottom,spacing: 6){
                            Text("\(Int( model.studyProgress))%")
                                .font(.title3.bold())
                            
                            Text("학습시간")
                                .font(.caption)
                                .foregroundColor(Color(.black))
                        }
                        
                    } icon: {
                        Group{
                            Image(systemName: "pencil")
                                .font(.title2)
                        }
                    }
                    .frame(maxWidth:.infinity)
                    Label{
                        HStack(alignment: .bottom,spacing: 6){
                            Text("\(Int(model.breakProgress))%")
                                .font(.title3.bold())
                            
                            Text("쉬는 시간")
                                .font(.caption)
                                .foregroundColor(Color(.black))
                        }
                        
                    } icon: {
                        Group{
                            Image(systemName: "clock")
                                .font(.title2)
                        }
                    }
                    .frame(maxWidth:.infinity)
                }
                .padding(.leading,10)
            }
        }
        .padding(.leading,10)
        .padding(.horizontal,20)
        .padding(.vertical,25)
        .background{
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color("Skyblue"))
        }
        
//        VStack(spacing: 15){
//
//            Text("Progress")
//                .fontWeight(.semibold)
//                .frame(maxWidth: .infinity, alignment: .leading)
//            HStack(spacing: 20){
//                ZStack{
//                    // study time
//                    AnimatedRingView(model: model, showRing: false,index: 1,color: Color(.blue))
//                    // break time
//                    AnimatedRingViewB(model: model, showRing: false,index: 2,color: Color(.red))
//                }
//                .frame(width: 130, height: 130)
//
//                VStack(alignment: .leading,spacing: 12){
//                    Label{
//                        HStack(alignment: .bottom,spacing: 6){
//                            Text("\(Int( model.studyProgress))%")
//                                .font(.title3.bold())
//
//                            Text("학습시간")
//                                .font(.caption)
//                                .foregroundColor(Color(.black))
//                        }
//
//                    } icon: {
//                        Group{
//                            Image(systemName: "pencil")
//                                .font(.title2)
//                        }
//                    }
//                    .frame(maxWidth:.infinity)
//                    Label{
//                        HStack(alignment: .bottom,spacing: 6){
//                            Text("\(Int(model.breakProgress))%")
//                                .font(.title3.bold())
//
//                            Text("쉬는 시간")
//                                .font(.caption)
//                                .foregroundColor(Color(.black))
//                        }
//
//                    } icon: {
//                        Group{
//                            Image(systemName: "clock")
//                                .font(.title2)
//                        }
//                    }
//                    .frame(maxWidth:.infinity)
//                }
//                .padding(.leading,10)
//            }
//        }
//        .padding(.leading,10)
//        .padding(.horizontal,20)
//        .padding(.vertical,25)
//        .background{
//            RoundedRectangle(cornerRadius: 25, style: .continuous)
//                .fill(Color("Skyblue"))
//        }
    }
    
}

struct Analysis_Previews: PreviewProvider {
    static var previews: some View {
        Analysis(model: .init())
    }
}

struct AnimatedRingViewB: View{
    
    @ObservedObject var model: ViewModel
    @State var showRing: Bool = false
    var index: Int
    var color: Color
    
    var body: some View{
        ZStack{
            Circle()
                .stroke(.gray.opacity(0.3),lineWidth: 15)
            Circle()
                .trim(from: 0, to: showRing ? model.breakProgress / 100 : 0)
                .stroke(color,style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                .rotationEffect(.init(degrees: -90))
        }
        .padding(CGFloat(index) * 20)
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
                withAnimation(.interactiveSpring(response: 1, dampingFraction: 1, blendDuration: 1).delay(0.1)){
                    showRing = true
                }
            }
        }
        
    }
}

struct AnimatedRingView: View{
    
    @ObservedObject var model: ViewModel
    @State var showRing: Bool = false
    var index: Int
    var color: Color
    
    var body: some View{
        ZStack{
            Circle()
                .stroke(.gray.opacity(0.3),lineWidth: 15)
            Circle()
                .trim(from: 0, to: showRing ? model.studyProgress / 100 : 0)
                .stroke(color,style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                .rotationEffect(.init(degrees: -90))
        }
        .padding(CGFloat(index) * 20)
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
                withAnimation(.interactiveSpring(response: 1, dampingFraction: 1, blendDuration: 1).delay(0.1)){
                    showRing = true
                }
            }
        }
        
    }
}
