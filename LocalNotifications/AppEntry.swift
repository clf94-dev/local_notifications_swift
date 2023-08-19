//
// Created for LocalNotifications
// by Stewart Lynch on 2022-05-22
// Using Swift 5.0
//
// Follow me on Twitter: @StewartLynch
// Subscribe on YouTube: https://youTube.com/StewartLynch
//

import SwiftUI

@main
struct AppEntry: App {
    @StateObject var lnManager = LocalNotificationsManager()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(lnManager)
        }
    }
}
