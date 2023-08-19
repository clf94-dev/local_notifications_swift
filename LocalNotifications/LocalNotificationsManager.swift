//
//  LocalNotificationsManager.swift
//  LocalNotifications
//
//  Created by Carmen Lucas on 19/8/23.
//

import Foundation
import NotificationCenter

@MainActor
class LocalNotificationsManager: ObservableObject {
    let notificationCenter = UNUserNotificationCenter.current()
    @Published var isGranted = false
    
    func requestAuthorization() async throws {
        try await notificationCenter.requestAuthorization(options: [.sound, .badge, .alert])
        await getCurrentSettings()
    }
    
    func getCurrentSettings() async {
        let currentSettings = await notificationCenter.notificationSettings()
        isGranted = (currentSettings.authorizationStatus == .authorized)
        print(isGranted)
    }
    
    func openSettings(){
        if let url = URL(string: UIApplication.openSettingsURLString){
            if UIApplication.shared.canOpenURL(url){
                Task {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    func schedule(localNotification: LocalNotification) async {
        let content = UNMutableNotificationContent()
        content.title = localNotification.title
        content.body = localNotification.body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: localNotification.timeInterval, repeats: false)
        
        let request = UNNotificationRequest(identifier: localNotification.identifier, content: content, trigger: trigger)
        
        try? await notificationCenter.add(request)
    }
    
}
