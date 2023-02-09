//
//LocalNotificationBootcamp.swift
//Day1
//
//Created by 서종현 on 2023/02/08.
//

import UserNotifications

class NotificagtionManager: ObservableObject {
    
//    @Published var instance = NotificagtionManager() // Singleton
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("ERROR: \(error)")
            } else {
                print("SUCCESS")
            }
        }
    }
    
    func scheduleNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "LEt's girit title bro"
        content.subtitle = "Subtitle BRO"
        content.sound = .default
        content.badge = 1
        
        //calendar
        var dateComponents = DateComponents()
        dateComponents.hour = 8
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
}
