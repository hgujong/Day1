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
    
    // MARK: Fetching Task
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.deadline, ascending: false)], predicate: nil, animation: .easeOut) var tasks: FetchedResults<Task>
    
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Todoy")
                        .font(.title.bold())
                        .foregroundColor(Color("ThemeColor"))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(.vertical)
                
                CustomSegmentedBar()
                    .padding(.top, 5)
                
                HStack(spacing: 5) {
                    
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
                        .foregroundColor(model.isToday(date: day) ? .white : .gray)
                        .frame(width: 48, height: 90)
                        .background(
                            
                            ZStack{
                                // MARK: Matched Geometry Effect
                                if model.isToday(date: day) {
                                    Capsule()
                                        .fill(Color("ThemeColor"))
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
                
                TaskView()
            }
            .padding()
            
        }
        .overlay(alignment: .bottom){
            Button {
                model.openEditTask.toggle()
            } label: {
                Label {
                    Text("New")
                        .font(.callout)
                        .fontWeight(.semibold)
                } icon: {
                    Image(systemName: "plus.app.fill")
                }
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(Color("ThemeColor"), in: Capsule())
            }
            .padding()
//            .frame(maxWidth: .infinity)
//            .background{
//                LinearGradient(colors: [
//                    .white.opacity(0.05),
//                    .white.opacity(0.4),
//                    .white.opacity(0.7),
//                    .white
//                ],startPoint: .top, endPoint: .bottom)
//                .ignoresSafeArea()
//            }
        }
        .fullScreenCover(isPresented: $model.openEditTask) {
            model.resetData()
        } content: {
            AddNewTask(model: model)
        }
    }
    
    // MARK: TaskView
    @ViewBuilder
    func TaskView()-> some View {
        LazyVStack(spacing: 20) {
//            ForEach(tasks){ task in
//                TaskRowView(task: task)
//            }
            DynamicFilteredView(model: model, currentTab: model.currentTab) { (task: Task) in
                TaskRowView(task: task)
            }
        }
        .padding(.top, 20)
    }
    
    // MARK: Task Row View
    @ViewBuilder
    func TaskRowView(task: Task)-> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Todo")
                    .font(.callout)
                    .fontWeight(.bold)
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    .foregroundColor(.white)
                    .background{
                        Capsule()
                            .fill(.gray.opacity(0.3))
                    }
                
                Spacer()
                
                // MARK: Edit button only for Non Completed Tasks
                if !task.isCompleted{
                    Button{
                        model.editTask = task
                        model.openEditTask = true
                        model.setupTask()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.white)
                    }
                }
                
            }
            
            Text(task.content ?? "")
                .font(.title2.bold())
                .foregroundColor(.white)
                .padding(.vertical, 10)
            
            HStack(alignment: .bottom, spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    Label {
                        Text((task.deadline ?? Date()).formatted(date: .long, time: .omitted))
                            .foregroundColor(.white)
                    } icon: {
                        Image(systemName: "calendar")
                            .foregroundColor(.white)
                    }
                    .font(.caption)
                    
                    Label {
                        Text((task.deadline ?? Date()).formatted(date: .omitted, time: .shortened))
                            .foregroundColor(.white)
                    } icon: {
                        Image(systemName: "clock")
                            .foregroundColor(.white)
                    }
                    .font(.caption)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if !task.isCompleted{
                    Button{
                        // MARK: Updating Core Data
                        task.isCompleted.toggle()
                        try? context.save()
                    } label: {
                        Circle()
                            .strokeBorder(.white, lineWidth: 1.5)
                            .frame(width: 25, height: 25)
                            .contentShape(Circle())
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background{
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(task.color ?? "Color 1"))
        }
    }
    
    // MARK: Custom Segmented Bar
    @ViewBuilder
    func CustomSegmentedBar() -> some View {
        let tabs = ["Todo", "Failed", "Task Done"]
        HStack(spacing: 10) {
            ForEach(tabs, id: \.self) { tab in
                Text(tab)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .scaleEffect(0.9)
                    .foregroundColor(model.currentTab == tab ? .white : Color("ThemeColor"))
                    .padding(.vertical,6)
                    .frame(maxWidth: .infinity)
                    .background{
                        if model.currentTab == tab {
                            Capsule()
                                .fill(Color("ThemeColor"))
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
