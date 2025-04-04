import Foundation
import UserNotifications

class HabitStore: ObservableObject {
    @Published var habits: [Habit] = [] {
        didSet {
            saveHabits()
        }
    }
    
    private let saveKey = "saved_habits"
    
    init() {
        loadHabits()
        checkAndResetHabits()   
    }
    
    func add(habit: Habit) {
        habits.append(habit)
        if habit.notificationsEnabled, let _ = habit.notificationDate {
            sendNotification(for: habit)
        }
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let habit = habits[index]
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [habit.id.uuidString])
        }
        habits.remove(atOffsets: offsets)
    }
    
    func completeHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index].lastCompleted = Date()
        }
    }
    
    func resetCompletion(for habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index].lastCompleted = nil
        }
    }
    
    private func saveHabits() {
        if let encoded = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadHabits() {
        if let savedData = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Habit].self, from: savedData) {
            habits = decoded
        }
    }
    
    
    func checkAndResetHabits() {
        let calendar = Calendar.current
        let now = Date()
        
        for index in habits.indices {
            var habit = habits[index]
            
            if habit.needAReset() {
                habits[index].lastCompleted = nil
                habits[index].lastReset = now
            }   
        }
    }
    
    func sendNotification(for habit: Habit) {
        guard let notificationDate = habit.notificationDate, habit.notificationsEnabled else { return }
        
        let content = UNMutableNotificationContent()
        
        content.title = "hey, track your reminder - \(habit.name)"
        content.body = "dont make me remind you again 👊"
        content.sound = .defaultCritical
        
        let calendar = Calendar.current
        let baseComponents = calendar.dateComponents([.hour, .minute], from: notificationDate)
        
        var triggerComponents = DateComponents()
        triggerComponents.hour = baseComponents.hour
        triggerComponents.minute = baseComponents.minute
        
        switch habit.frequency.lowercased() {
        case "daily":
            break
            
        case "weekly":
            let weekday = calendar.component(.weekday, from: notificationDate)
            triggerComponents.weekday = weekday
            
        case "monthly":
            let day = calendar.component(.day, from: notificationDate)
            triggerComponents.day = day
            
        default:
            break
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: habit.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
    }
}
