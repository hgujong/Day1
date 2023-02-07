//
//  DynamicFilteredView.swift
//  Day1
//
//  Created by 서종현 on 2023/02/07.
//

import SwiftUI
import CoreData

struct DynamicFilteredView<Content: View,T>: View where T: NSManagedObject {
    // MARK: Core Data Request
    @FetchRequest var request: FetchedResults<T>
    let content: (T)-> Content
    @ObservedObject var model: ViewModel
    
    // MARK: Building Custom ForEach which will give CoreData object to build View
    init(model: ViewModel, currentTab: String, @ViewBuilder content: @escaping (T)->Content){
        self.model = model
        // MARK: Predicate to Filter current date Tasks
        let calendar = Calendar.current
        var predicate: NSPredicate!
        if currentTab == "Today"{
            let currentDay = calendar.startOfDay(for: model.currentDay)
            let today = calendar.startOfDay(for: Date())
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: currentDay)!
            
            //Filter Key
            let filterKey = "deadline"
            
            //This will fetch task between today and tomorrow which is 24 hrs
            // 0 - false, 1 - true
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today, currentDay, tomorrow, 0])
        }else if currentTab == "Failed"{
            let currentDay = calendar.startOfDay(for: model.currentDay)
            let today = calendar.startOfDay(for: Date())
            
            //Filter Key
            let filterKey = "deadline"
            
            //This will fetch task between today and tomorrow which is 24 hrs
            // 0 - false, 1 - true
            predicate = NSPredicate(format: "%@ < %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [currentDay, today, today, 0])
        }else{
            let currentDay = calendar.startOfDay(for: model.currentDay)
            let today = calendar.startOfDay(for: Date())
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: currentDay)!
            
            //Filter Key
            let filterKey = "deadline"
            
            //This will fetch task between today and tomorrow which is 24 hrs
            // 0 - false, 1 - true
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [currentDay, tomorrow, 1])
        }
        
        // Initializing Request With SDPredicate
        _request = FetchRequest(entity: T.entity(), sortDescriptors: [.init(keyPath: \Task.deadline, ascending: false)], predicate: predicate)
        self.content = content
    }
    
    var body: some View {
        
        Group{
            if request.isEmpty{
                Text("No Todo Found")
                    .font(.system(size: 16))
                    .fontWeight(.light)
                    .offset(y: 100)
            }
            else {
                
                ForEach(request,id: \.objectID){object in
                    self.content(object)
                }
            }
        }
    }
}
