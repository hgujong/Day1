//
//  ViewModel.swift
//  Day1
//
//  Created by 서종현 on 2023/02/02.
//

import SwiftUI
import CoreData

class ViewModel: ObservableObject{
    @Published var currentTab: String = "Todo"
    @Published var content = ""
    @Published var date = Date()
    @Published var color: String = "Color 1"
    @Published var taskTitle: String = ""
    @Published var openEditTask: Bool = false
    

    // MARK: Editing Existing Task Data
    @Published var editTask: Task?
    
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
    
    
    // 새로운 모델
    
    func addData(context: NSManagedObjectContext)->Bool {
        // MARK: Updating Existing Date in Core Data
        var task: Task!
        if let editTask = editTask{
            task = editTask
        } else{
            task = Task(context: context)
        }
        task.content = content
        task.color = color
        task.deadline = Calendar.current.startOfDay(for: currentDay).addingTimeInterval(86399)//currentDay
        task.isCompleted = false
        
        if let _ = try? context.save(){
            return true
        }
        return false
    }
    
    func resetData(){
        color = "Color 1"
        date = Date()
        content = ""
        
    }
    
    func setupTask(){
        if let editTask = editTask{
            color = editTask.color ?? "Color 1"
            content = editTask.content ?? ""
            currentDay = editTask.deadline  ?? Date()
        }
    }
    
    
    
    //MARK: 스톱워치 관련 함수 및 변수
    
    @Published var progress: CGFloat = 0
    @Published var timeStringValue: String = "00:00"
    @Published var isStarted: Bool = false
    @Published var addNewTimer: Bool = false
    
    @Published var hour: Int = 0
    @Published var min: Int = 0
    @Published var sec: Int = 0
    
    //목표시간 관련 변수
    @Published var setTimeStringValue: String = "00:00"
    @Published var setHour: Int = 0
    @Published var setMin: Int = 0
    @Published var setSec: Int = 0
    
    //
    @Published var totalSec: Int = 0
    @Published var staticTotalSec: Int = 0
    
    //MARK: 타이머 시작
    func startTimer(){
        withAnimation(.easeInOut(duration: 0.25)){isStarted = true
            timeStringValue = "\(hour == 0 ? "" : "\(hour):")\(min >= 10 ? "\(min):":"0\(min):")\(sec >= 10 ? "\(sec)":"0\(sec)")"
            setTimeStringValue = "\(setHour == 0 ? "" : "\(setHour):")\(setMin >= 10 ? "\(setMin):":"0\(setMin):")\(setSec >= 10 ? "\(setSec)":"0\(setSec)")"
            
            totalSec = (hour * 3600) + (min * 60) + sec
            staticTotalSec = (setHour * 3600) + (setMin * 60) + setSec
            addNewTimer = false
            
        }
    }
    
    //MARK: 타이머 정지
    func stopTimer(){
        withAnimation{
            isStarted = false
        }
    }
    
    //MARK: 목표시간 재설정 및 정지
    func resetTimer(){
        withAnimation{
            isStarted = false
            totalSec = 0
            setTimeStringValue = "00:00"
            setHour = 0
            setMin = 0
            setSec = 0
        }
    }
    
    //MARK: 타이머 업데이트
        func updatingTimer(){
            totalSec += 1
            progress = CGFloat(totalSec) / CGFloat(staticTotalSec)
            progress = (progress < 0 ? 0 : progress)
            hour = totalSec / 3600
            min = (totalSec / 60 ) % 60
            sec = (totalSec % 60)
            timeStringValue = "\(hour == 0 ? "" : "\(hour):")\(min >= 10 ? "\(min):":"0\(min):")\(sec >= 10 ? "\(sec)":"0\(sec)")"
            
            if hour == 0 && sec == 0 && min == 0 {
                isStarted = false
                print("Finished")
            }
        }
    
    
    //MARK: 도표 관련 변수 및 함수
    
    @Published var isText: Bool = false
    //타이머 및 링 출력할 것들 계산
    @Published var studyTime: CGFloat = 0
    @Published var breakTime: CGFloat = 0
    @Published var willstudyTime: CGFloat = 0
    @Published var willbreakTime: CGFloat = 0
    
    //링에 출력할 것들
    @Published var studyProgress: CGFloat = 0
    @Published var breakProgress: CGFloat = 0
    
    
    
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
