//
//  HomeView.swift
//  habittracker
//
//  Created by Divpreet Singh on 09/02/2025.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack{
            Color(hex:0x080808)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                HeaderView()
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                
                if true { 
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 64))
                            .foregroundColor(.gray)
                        
                        Text("no habits yet")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("tap + to create your first habit")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
            }
        }
    }
}

struct HeaderView: View {
    @State private var createScreen = false
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .font: UIFont.boldSystemFont(ofSize: 17)
        ]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: {
                print("opened settings")
            }) {
                Image(systemName: "switch.2")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            HStack(spacing: 4) {
                Text(dateFormatter.string(from: Date()))
                    .font(.system(size: 18))
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            Button(action: {
                createScreen.toggle()
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
            }
        }
        .sheet(isPresented: $createScreen) {
            NavigationView {
                CreateView()
                    .navigationBarTitle("New Habit", displayMode: .inline)

                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") {
                                createScreen = false
                            }
                            .foregroundColor(.white)

                        }
                }
            }
        }
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
