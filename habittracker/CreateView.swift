import SwiftUI

struct CreateView: View {
    @State private var habitName = ""
    @State private var habitDesc = ""
    @State private var habitColor = Color.red
    @State private var showCustomPicker = false
    @State private var notifications = false

    enum Frequency: String, CaseIterable {
        case daily = "Daily"
        case weekly = "Weekly"
        case monthly = "Monthly"
    }
    @State private var selectedFrequency: Frequency = .daily

    let presetColors: [Color] = [
        .red, .yellow, .green, .blue
    ]
    
    // Computed property to check if the button should be disabled
    var isCreateButtonDisabled: Bool {
        habitName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        habitDesc.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        VStack(spacing: 0) {
            Form {
                Section {
                    TextField("Habit Name", text: $habitName)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    TextField("Habit Description", text: $habitDesc)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                Section {
                    HStack {
                        Text("Habit Frequency")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Picker("", selection: $selectedFrequency) {
                            ForEach(Frequency.allCases, id: \.self) { frequency in
                                Text(frequency.rawValue)
                                    .font(.system(size: 17, weight: .bold))
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .foregroundColor(.white)
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
                            
                            Text("Receive notifications as reminders to keep your habit going!")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    .tint(.blue)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(hex: 0x080808))
            
            // Create Habit Button
            Button(action: {
                print(habitName)
            }) {
                Text("Create Habit")
                    .fontWeight(.bold)
                    .foregroundColor(isCreateButtonDisabled ? Color.white.opacity(0.6) : .black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isCreateButtonDisabled ? Color.gray : Color.white)
                    .cornerRadius(10)
            }
            .padding()
            // Disable the button if either field is empty
            .disabled(isCreateButtonDisabled)
        }
        .background(Color(hex: 0x080808).edgesIgnoringSafeArea(.all))
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}
