//
//  LocalNotification.swift
//  LocalNotifications
//
//  Created by Carmen Lucas on 19/8/23.
//

import Foundation
struct LocalNotification {
    
    internal init(identifier: String, title: String, body: String, timeInterval: Double, repeats: Bool) {
        self.identifier = identifier
        self.scheduleType = .time
        self.title = title
        self.body = body
        self.timeInterval = timeInterval
        self.repeats = repeats
        self.dateComponents = nil
    }
    internal init(identifier: String, title: String, body: String, repeats: Bool, dateComponents: DateComponents) {
        self.identifier = identifier
        self.title = title
        self.scheduleType = .calendar
        self.body = body
        self.timeInterval = nil
        self.repeats = repeats
        self.dateComponents = dateComponents
    }
    
    enum ScheduleType {
        case time, calendar
    }
    
    var identifier: String
    var scheduleType: ScheduleType
    var title: String
    var body: String
    var timeInterval: Double?
    var repeats: Bool
    var dateComponents: DateComponents?
}
