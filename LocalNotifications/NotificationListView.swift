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
    @State var scheduleDate = Date()
    var body: some View {
        NavigationView {
            VStack {
                if lnManager.isGranted {
                    GroupBox("Schedule") {
                        Button("Interval Notification") {
                            Task {
                                var localNotification = LocalNotification(identifier: UUID().uuidString, title: "Some title", body: "some body", timeInterval: 10, repeats: false)
                                localNotification.subtitle = "This is a subtitle"
                                localNotification.bundleImageName = "Stewart.png"
                                localNotification.userInfo = ["nextView": NextView.renew.rawValue]
                                localNotification.categoryIdentifier = "snooze"
                                await lnManager.schedule(localNotification: localNotification)
                            }
                        }
                        .buttonStyle(.bordered)
                        GroupBox {
                            DatePicker("", selection: $scheduleDate)
                            Button("Calendar Notification") {
                                Task {
                                    let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: scheduleDate)
                                    let localNotification = LocalNotification(identifier: UUID().uuidString, title: "Calendar notification", body: "Some body", repeats: false, dateComponents: dateComponents)
                                    
                                    await lnManager.schedule(localNotification: localNotification)
                                }
                            }
                            .buttonStyle(.bordered)
                        }
                        Button ("Promo Offer") {
                            Task {
                                let dateComponents = DateComponents(day: 20, hour: 17, minute: 0)
                                var localNotification = LocalNotification(identifier: UUID().uuidString, title: "Special Promotion", body: "Take advantage of the monthly promotion", repeats: true, dateComponents: dateComponents)
                                localNotification.bundleImageName = "Stewart.png"
                                localNotification.userInfo = ["nextView": NextView.promo.rawValue]
                                await lnManager.schedule(localNotification: localNotification)
                            }
                        }
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
            .sheet(item: $lnManager.nextView, content: {nextView in
                nextView.view()
            })
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
