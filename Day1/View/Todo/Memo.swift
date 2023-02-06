//
//  Memo.swift
//  Day1
//
//  Created by 서종현 on 2023/02/02.
//

import SwiftUI
import CoreData

struct Memo: View {
    @ObservedObject var model: ViewModel
    @Namespace var animation
    
    //fetching data
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(key: "date", ascending: true)],animation: .spring()) var results : FetchedResults<Task>
    @Environment(\.managedObjectContext) var context
    
    
    
    var body: some View {
        
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom), content: {
            VStack(spacing: 0){
                
                HStack{
                    
                    Text("Tasks")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                    
                    Spacer(minLength: 0)
                }
                .padding()
                .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
                .background(Color.white)
                
                CustomSegmentedBar()
                    .padding(.vertical)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack(spacing: 10) {
                        
                        ForEach(model.currentweek, id: \.self) { day in
                            
                            VStack(spacing: 10) {
                                
                                //날짜
                                Text(model.extractDate(date: day, format: "dd"))
                                    .font(.system(size: 15))
                                    .fontWeight(.semibold)
                                
                                // Mon, Tue, Wed...
                                Text(model.extractDate(date: day, format: "EEE"))
                                    .font(.system(size: 14))
                                
                                Circle()
                                    .fill(.white)
                                    .frame(width: 8, height: 8)
                                    .opacity(model.isToday(date: day) ? 1 : 0)
                                
                            }
                            .foregroundStyle(model.isToday(date: day) ? .primary : .secondary)
                            .foregroundColor(model.isToday(date: day) ? .white : .black)
                            .frame(width: 48, height: 90)
                            .background(
                                
                                ZStack{
                                    // MARK: Matched Geometry Effect
                                    if model.isToday(date: day) {
                                        Capsule()
                                            .fill(.black)
                                            .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
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
                    
                }
                
                List {
                    ForEach(results) {task in
                        
                        VStack(alignment: .leading,spacing: 5, content: {
                            
                            Text(task.content ?? "")
                                .fontWeight(.bold)
                            
                            Text(task.date ?? Date(), style: .date)
                                .font(.footnote)
                        })
                        .foregroundColor(.black)
                    }
                    .onDelete{ indexSet in
                        for index in indexSet {
                            self.context.delete(self.results[index])
                            try? self.context.save()
                        }
                    }
                }
                
                
            }
            
            Button(action: {model.isNewData.toggle()}, label: {
                Image(systemName: "plus")
//                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(20)
                    .background(
                        AngularGradient(gradient: .init(colors: [Color.indigo,Color.blue,]), center: .center)
                    )
                    .clipShape(Circle())
            })
            .padding()
            .padding([.bottom],50)
        })
        .ignoresSafeArea(.all, edges: .top)
        .background(Color.black.opacity(0.06).ignoresSafeArea(.all,edges: .all))
        .sheet(isPresented: $model.isNewData, content: {
            
            NewDataView(model: model)
            
        })
    }
    
    @ViewBuilder
    func CustomSegmentedBar() -> some View {
        let tabs = ["Today", "Task Done", "Failed"]
        HStack(spacing: 10) {
            ForEach(tabs, id: \.self) { tab in
                Text(tab)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .scaleEffect(0.9)
                    .foregroundColor(model.currentTab == tab ? .white : .black)
                    .padding(.vertical,6)
                    .frame(maxWidth: .infinity)
                    .background{
                        if model.currentTab == tab {
                            Capsule()
                                .fill(.black)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                    .contentShape(Capsule())
                    .onTapGesture {
                        withAnimation{model.currentTab = tab}
                    }
            }
        }
    }
}

struct Memo_Previews: PreviewProvider {
    static var previews: some View {
        Memo(model: .init())
    }
}
