import SwiftUI

struct HabitCard: View {
    let habit: Habit
    
    var onComplete: (() -> Void)?

    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text(habit.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(habit.description)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.6))
                    .lineLimit(2)
            }
            
            Spacer()
            
            if habit.isCompletedForToday {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(Color(hex: habit.colorHex))
            } else {
                Button(action: {
    
                    onComplete?()
                }) {
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 32))
                        .foregroundColor(.gray)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 24)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(hex: habit.colorHex))
                        .opacity(0.30)
                )
        )
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}
