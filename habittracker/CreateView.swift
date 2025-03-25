//
//  CreateView.swift
//  habittracker
//
//  Created by Divpreet Singh on 25/03/2025.
//

import SwiftUI

struct CreateView: View {
    @State private var habitName = ""
    @State private var habitDesc = ""

    // Example Frequency enum
    enum Frequency: String, CaseIterable {
        case daily = "Daily"
        case weekly = "Weekly"
        case monthly = "Monthly"
    }
    @State private var selectedFrequency: Frequency = .daily

    var body: some View {
        ZStack {
            Color(hex: 0x080808)
                .edgesIgnoringSafeArea(.all)
            
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
                        .foregroundColor(.white)
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}
