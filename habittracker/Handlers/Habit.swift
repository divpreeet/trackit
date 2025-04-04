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
    var lastReset: Date? = nil
    
    var isCompletedForToday: Bool {
        guard let last = lastCompleted else { return false }
        return Calendar.current.isDateInToday(last)
    }
    
    mutating func needAReset() -> Bool {
        guard let lastReset = lastReset else { return true }
        let calendar = Calendar.current
        let now = Date()
        
        switch frequency.lowercased() {
        case "daily":
            return !calendar.isDate(lastReset, inSameDayAs: now)
        
        case "weekly":
            return !calendar.isDate(lastReset, equalTo: now, toGranularity: .weekOfYear)
        
        case "monthly":
            return !calendar.isDate(lastReset, equalTo: now, toGranularity: .month)
            
        default:
            return false
        }
    }
}
