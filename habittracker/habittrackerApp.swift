//
//  habittrackerApp.swift
//  habittracker
//
//  Created by Divpreet Singh on 08/02/2025.
//

import SwiftUI
import UserNotifications

@main
struct habittrackerApp: App {
    init() {
        requestNotificationPermission()
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
            if success {
                print("Notifications allowed")
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

