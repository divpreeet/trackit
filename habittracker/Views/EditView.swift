import SwiftUI

struct EditView: View {
    @State private var habitName: String
    @State private var habitDesc: String
    @State private var habitColor: Color
    @State private var showCustomPicker = false
    @State private var notifications: Bool
    @State private var selectedFrequency: Frequency
    @State private var notificationTime: Date
    
    let habit: Habit
    
    enum Frequency: String, CaseIterable {
        case daily = "Daily"
        case weekly = "Weekly"
        case monthly = "Monthly"
    }
    
    let presetColors: [Color] = [
        .red, .yellow, .green, .blue
    ]
    
    @EnvironmentObject var habitStore: HabitStore
    @Environment(\.presentationMode) var presentationMode
    
    init(habit: Habit) {
        self.habit = habit
        _habitName = State(initialValue: habit.name)
        _habitDesc = State(initialValue: habit.description)
        _habitColor = State(initialValue: Color(hex: habit.colorHex))
        _notifications = State(initialValue: habit.notificationsEnabled)
        _notificationTime = State(initialValue: habit.notificationDate ?? Date())
        
        let freq = Frequency.allCases.first { $0.rawValue == habit.frequency } ?? .daily
        _selectedFrequency = State(initialValue: freq)
    }
    
    var isDisabled: Bool {
        habitName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        habitDesc.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        VStack(spacing: 0) {
            Form {
                Section {
                    TextField("Habit Name", text: $habitName)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 4)
                    
                    TextField("Habit Description", text: $habitDesc)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .padding(.vertical, 4)
                }
                
                Section {
                    HStack {
                        Text("Habit Frequency")
                            .font(.system(size: 17))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Picker("", selection: $selectedFrequency) {
                            ForEach(Frequency.allCases, id: \.self) { frequency in
                                Text(frequency.rawValue)
                                    .font(.system(size: 17, weight: .medium))
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .foregroundColor(.white)
                        .tint(Color.blue)
                    }
                }
                
                Section {
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 5)) {
                        ForEach(presetColors, id: \.self) { color in
                            Circle()
                                .fill(color)
                                .frame(width: 35, height: 35)
                                .overlay(
                                    Circle()
                                        .stroke(habitColor == color ? Color.white.opacity(0.8) : Color.clear,
                                                lineWidth: 3)
                                )
                                .onTapGesture {
                                    habitColor = color
                                }
                        }
                        
                        Button(action: {
                            showCustomPicker.toggle()
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 35, height: 35)
                                    .overlay(
                                        Image(systemName: "ellipsis")
                                            .foregroundColor(.black)
                                    )
                                    .shadow(radius: 2)
                            }
                        }
                    }
                    .padding(.vertical, 5)
                    
                    if showCustomPicker {
                        ColorPicker("Pick a custom color",
                                    selection: $habitColor,
                                    supportsOpacity: false)
                        .padding(.vertical, 5)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    }
                }
                
                Section {
                    Toggle(isOn: $notifications) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Enable Notifications")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.white)
    
                            
                            Text("Receive reminders to keep your habit going!")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    .tint(Color.blue)
                    
                    if notifications {
                        DatePicker(
                            "Notification Time",
                            selection: $notificationTime,
                            displayedComponents: .hourAndMinute
                        )
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .accentColor(.blue)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(hex: 0x080808))
            
            Button(action: {
                if let index = habitStore.habits.firstIndex(where: { $0.id == habit.id }) {
                    let updatedHabit = Habit(name: habitName,
                                         description: habitDesc,
                                         frequency: selectedFrequency.rawValue,
                                         colorHex: habitColor.toHex,
                                         notificationsEnabled: notifications,
                                         creationDate: habit.creationDate,
                                         lastCompleted: habit.lastCompleted,
                                         notificationDate: notificationTime)
                    habitStore.habits[index] = updatedHabit
                }
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save Changes")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(isDisabled ? Color.gray : Color.white)
                    )
                    .animation(.easeInOut(duration: 0.2), value: isDisabled)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .disabled(isDisabled)
        }
        .background(Color(hex: 0x080808).edgesIgnoringSafeArea(.all))
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleHabit = Habit(name: "habit",
                               description: "goofy ahh",
                               frequency: "Daily", 
                               colorHex: 0xFF0000, 
                               notificationsEnabled: false, 
                               creationDate: Date(),
                               notificationDate: Date())
        EditView(habit: sampleHabit)
    }
}
