//
//  ViewModel.swift
//  Day1
//
//  Created by 서종현 on 2023/02/02.
//

import SwiftUI
import CoreData

class ViewModel: ObservableObject{
    @Published var currentTab: String = "Today"
    @Published var content = ""
    @Published var date = Date()
    @Published var color: String = "Yellow"
    @Published var taskDeadline: Date = Date()
    @Published var taskTitle: String = ""
    
    @Published var isNewData = false
    
    //Check and update date
    
    //Storing update item
    
    @Published var updateItem : Task!
    
    let calender = Calendar.current
    
    func checkDate()->String{
        if calender.isDateInToday(date){
            return "Today"
        }
        else if calender.isDateInTomorrow(date){
            return "Tomorrow"
        }
        else{
            return "Other day"
        }
    }
    
    func updateDate(value: String){
        if value == "Today"{date = Date()}
        else if value == "Tomorrow"{
            date = calender.date(byAdding: .day, value: 1, to: Date())!
        }
        else{
            
        }
    }
    
    func writeData(context : NSManagedObjectContext){
        
        //update item
        
        if updateItem != nil{
            
            updateItem.date = date
            updateItem.content = content
            
            try! context.save()
            
            updateItem = nil
            isNewData.toggle()
            return
        }
        let newTask = Task(context: context)
        newTask.date = date
        newTask.content = content
        
        do{
            try context.save()
            isNewData.toggle()
            content = ""
            date = Date()
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    func EditItem(item: Task){
        
        updateItem = item
        
        //togging the newDateView
        date = item.date!
        content = item.content!
        isNewData.toggle()
        
        
    }
    
    // ---------------------------------
    // Current Week Fetch
    
    // MARK: Current Week Days
    @Published var currentweek: [Date] = []
    
    // MARK: Current Day
    @Published var currentDay: Date = Date()
    
    // Initialize
    
    init() {
        fetchCurrentWeek()
    }
    
    func fetchCurrentWeek(){
        let today = Date()
        let calendar = Calendar.current
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = week?.start else {return}
        
        (0...6).forEach { day in
            
            if let weekday = calendar.date(byAdding: .day, value: day,  to: firstWeekDay){
                currentweek.append(weekday)
            }
        }
    }
    
    //Extract date
    
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    // Check if it is Today
    
    func isToday(date: Date) -> Bool {
        
        let calendar = Calendar.current
        
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
    
}
