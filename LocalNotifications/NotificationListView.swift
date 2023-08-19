//
// Created for LocalNotifications
// by Stewart Lynch on 2022-05-22
// Using Swift 5.0
//
// Follow me on Twitter: @StewartLynch
// Subscribe on YouTube: https://youTube.com/StewartLynch
//

import SwiftUI

struct NotificationListView: View {
    @EnvironmentObject var lnManager: LocalNotificationsManager
    @Environment(\.scenePhase) var scenePhase
    var body: some View {
        NavigationView {
            VStack {
                if lnManager.isGranted {
                    GroupBox("Schedule") {
                        Button("Interval Notification") {
                            Task {
                                let localNotification = LocalNotification(identifier: UUID().uuidString, title: "Some title", body: "some body", timeInterval: 5, repeats: false)
                                await lnManager.schedule(localNotification: localNotification)
                            }
                        }
                        .buttonStyle(.bordered)
                        Button("Calendar Notification") {
                            
                        }
                        .buttonStyle(.bordered)
                    }
                    .frame(width: 300)
                    List{
                        ForEach(lnManager.pendingRequests, id: \.identifier){ request in
                            VStack(alignment: .leading){
                                Text(request.content.title)
                                HStack{
                                    Text(request.identifier)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }.swipeActions{
                                Button("Delete", role: .destructive){
                                    lnManager.removeRequest(withIdentifier: request.identifier)
                                }
                            }
                            
                        }
                    }
                } else {
                    Button("Enable notifications") {
                        lnManager.openSettings()
                    }
                    .buttonStyle(.borderedProminent)
                }
                // List View Here
            }
            .navigationTitle("Local Notifications")
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        lnManager.clearRequests()
                    } label: {
                        Image(systemName: "clear.fill")
                            .imageScale(.large)
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
        .task {
            try? await lnManager.requestAuthorization()
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                Task {
                   await lnManager.getCurrentSettings()
                await lnManager.getPendingRequests()
                }
            }
            
        }
    }
}

struct NotificationListView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationListView()
            .environmentObject(LocalNotificationsManager())
    }
}
