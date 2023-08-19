//
// Created for LocalNotifications
// by Stewart Lynch on 2022-05-22
// Using Swift 5.0
//
// Follow me on Twitter: @StewartLynch
// Subscribe on YouTube: https://youTube.com/StewartLynch
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var lnManager: LocalNotificationsManager
    var body: some View {
        NavigationView {
            VStack {
                if lnManager.isGranted {
                    GroupBox("Schedule") {
                        Button("Interval Notification") {
                            
                        }
                        .buttonStyle(.bordered)
                        Button("Calendar Notification") {
                            
                        }
                        .buttonStyle(.bordered)
                    }
                    .frame(width: 300)
                } else {
                    Button("Enable notifications") {
                        lnManager.openSettings()
                    }
                    .buttonStyle(.borderedProminent)
                }
                // List View Here
            }
            .navigationTitle("Local Notifications")
        }
        .navigationViewStyle(.stack)
        .task {
            try? await lnManager.requestAuthorization()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(LocalNotificationsManager())
    }
}
