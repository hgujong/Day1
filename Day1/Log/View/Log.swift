//
//  Log.swift
//  TaskApp
//
//  Created by junhyeok KANG on 2023/02/07.
//

import SwiftUI

struct Log: View {
    
    @State var currentWeek: [Date] = []
    @State var currentDay: Date = Date()
    
    @State var showView: [Bool] = Array(repeating: false, count: 5)
    
    
    var body: some View {
        VStack(spacing: 20) {
            
            HStack{
                Text("요약")
                    .font(.system(size: 35))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Spacer()
                //공부 목표 시간,쉬는 시간 편집
                Button(action: {
                    
                }, label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title3)
                })
            }
            .foregroundColor(.blue)
            .opacity(showView[0] ?  1:0)
            .offset(y:showView[0] ? 0 : 200)
             //날짜 출력하는 부분
            HStack(spacing: 10){
                ForEach(currentWeek,id:  \.self){date in
                    Text(extractDate(date:date))
                        .font(.system(size: 20))
                        .foregroundColor(isSameDay(date1: currentDay, date2: date) ? .white : .black)
                        .fontWeight(isSameDay(date1: currentDay, date2: date) ? .bold : .semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, isSameDay(date1: currentDay, date2: date) ? 6 : 0)
                        .padding(.horizontal, isSameDay(date1: currentDay, date2: date) ? 12 : 0)
                        .frame(width: isSameDay(date1: currentDay, date2: date) ? 140 : nil)
                        .background{
                            Capsule()
                                .fill(Color("ThemeColor"))
                                .environment(\.colorScheme, .light)
                                .opacity(isSameDay(date1: currentDay, date2: date) ? 0.8 : 0)

                        }
                        .onTapGesture {
                            withAnimation {
                                currentDay = date
                            }
                        }
                }
               
            }
            .padding(.top,10)
            .opacity(showView[1] ?  1:0)
            .offset(y: showView[1] ? 0 : 250)
            
            VStack(alignment: .leading, spacing: 8){
                Text("금일 학습시간")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("1시간 30분")
                    .font(.system(size: 45, weight: .bold))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical,10)
            .opacity(showView[2] ?  1:0)
            .offset(y: showView[2] ? 0 : 200)
            
            //MARK: Ring View
            RingCardView()
                .opacity(showView[3] ?  1:0)
                .offset(y: showView[3] ? 0 : 200)
            
            //MARK: Bar Graph View
            StepsGraphView()
                .opacity(showView[4] ?  1:0)
                .offset(y: showView[4] ? 0 : 250)
        }
        .padding()
//        .onAppear(perform: extraCurrentWeek)
        .onAppear(perform: animateViews)
    }
    
    func animateViews(){
        
        withAnimation(.easeInOut){
            showView[0] = true
        }
        
        withAnimation(.easeInOut.delay(0.1)){
            showView[1] = true
        }
        withAnimation(.easeInOut.delay(0.15)){
            showView[2] = true
        }
        withAnimation(.easeInOut.delay(0.2)){
            showView[3] = true
        }
        withAnimation(.easeInOut.delay(0.35)){
            showView[4] = true
        }
    }
    
     
    //MARK: Extracting Current Week
    func extraCurrentWeek(){
        let calendar = Calendar.current
        let week = calendar.dateInterval(of: .weekOfMonth, for: Date())
        
        guard let firstsDay = week?.start else{
            return
        }
        
        (0..<7).forEach{ day in
            if let weekDay = calendar.date(byAdding: .day, value: day, to: firstsDay){
                currentWeek.append(weekDay)
            }
        }
    }
    
    //MARK: Extracting Custom Date Components
    func extractDate(date: Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = (isSameDay(date1: currentDay, date2: date) ? "dd MMM" : "dd")
        
        return formatter.string(from: date)
    }
    
    //MARK: Check Date is Today or Same day
    func isDateToday(date: Date)->Bool{
        let calendar = Calendar.current
        return calendar.isDateInToday(date)
    }
    
    func isSameDay(date1: Date, date2: Date)->Bool{
        let calendar = Calendar.current
        return calendar.isDate(date1,inSameDayAs: date2)
    }
}




struct Log_Previews: PreviewProvider {
    static var previews: some View {
        LogBackground()
    }
}
