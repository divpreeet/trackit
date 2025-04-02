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
    
    func sendNotification(for habit: Habit) {
        guard let notificationDate = habit.notificationDate, habit.notificationsEnabled else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder for : \(habit.name)"
        content.body = "Track your habit!"
        content.sound = .default
        
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: notificationDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: habit.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
