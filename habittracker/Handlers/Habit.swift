//
//  Habit.swift
//  habittracker
//
//  Created by Divpreet Singh on 26/03/2025.
//

import Foundation

struct Habit: Identifiable, Codable {
    let id = UUID()
    let name: String
    let description: String
    let frequency: String
    let colorHex: Int
    let notificationsEnabled: Bool
    let creationDate: Date
    var lastCompleted: Date? = nil
    let notificationDate: Date?
    
    var isCompletedForToday: Bool {
        guard let last = lastCompleted else { return false }
        return Calendar.current.isDateInToday(last)
    }
}
