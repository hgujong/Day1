//
//  Setting.swift
//  Day1
//
//  Created by 서종현 on 2023/02/02.
//

import SwiftUI
import CoreData
import UserNotifications

// Noti Manager
class NotificationManager: ObservableObject {
    
    let notiCenter = UNUserNotificationCenter.current()
    
    @Published var isToggleOn: Bool = UserDefaults.standard.bool(forKey: "hasUserAgreedNoti") {
        didSet {
            if isToggleOn {
                // On Action - 1
                UserDefaults.standard.set(true, forKey: "hasUserAgreedNoti")
                requestNotiAuthorization()
            }
            else {
                // Off Action - 2
                UserDefaults.standard.set(false, forKey: "hasUserAgreedNoti")
                removeAllNotifications()
            }
        }
    }
    
    @Published var notiTime: Date = Date() {
        didSet {
            // Set Notification with the Time - 3
            removeAllNotifications()
            addNotification(with: notiTime)
        }
    }
    
    @Published var isAlertOccurred: Bool = false
    
    
    func removeAllNotifications() {
        notiCenter.removeAllDeliveredNotifications()
        notiCenter.removeAllPendingNotificationRequests()
    }
    
    func requestNotiAuthorization() {
        // 노티피케이션 설정을 가져오기
        // 상태에 따라 다른 액션 수행
        notiCenter.getNotificationSettings { settings in
            
            // 승인되어있지 않은 경우 request
            if settings.authorizationStatus != .authorized {
                self.notiCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                    if let error = error {
                        print("Error : \(error)")
                    }
                    
                    // 노티피케이션 최초 승인
                    if granted {
                        self.addNotification(with: self.notiTime)
                    }
                    // 노티피케이션 최초 거부
                    else {
                        DispatchQueue.main.async {
                            self.isToggleOn = false
                        }
                    }
                }
            }
            
            // 거부되어있는 경우 alert
            if settings.authorizationStatus == .denied {
                // 알림 띄운 뒤 설정 창으로 이동
                DispatchQueue.main.async {
                    self.isAlertOccurred = true
                }
            }
        }
    }
    
    func addNotification(with time: Date) {
        let content = UNMutableNotificationContent()
        
        content.title = "Let's Git It!"
        content.subtitle = "오늘도 빡공 하셨나요?"
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        let dateComponent = Calendar.current.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        notiCenter.add(request)
    }
    
    func openSettings() {
        if let bundle = Bundle.main.bundleIdentifier,
           let settings = URL(string: UIApplication.openSettingsURLString + bundle) {
            if UIApplication.shared.canOpenURL(settings) {
                UIApplication.shared.open(settings)
            }
        }
    }
    
}

struct Setting: View {
    @ObservedObject var model: ViewModel
    @State var notificationOn = false
    @ObservedObject private var notiManager = NotificationManager()
    
    var body: some View {
        List {
            Section{
                VStack {
                    Toggle("알림", isOn: $notiManager.isToggleOn)
                        .toggleStyle(SwitchToggleStyle(tint: Color("ThemeColor")))
                    if notiManager.isToggleOn {
                        DatePicker("", selection: $notiManager.notiTime, displayedComponents: .hourAndMinute)
                    }
                }
            }
            Section {
                Text("TODOY를 이용해주셔서 감사합니다:)")
            }
            
        }
    }
}

struct Setting_Previews: PreviewProvider {
    static var previews: some View {
        Setting(model: .init())
    }
}
