import SwiftUI

struct HomeView: View {
    @StateObject var habitStore = HabitStore()
    @State private var editingHabit: Habit? = nil
    @State private var showEditSheet = false
    
    var body: some View {
        ZStack {
            Color(hex: 0x080808)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                HeaderView()
                    .environmentObject(habitStore)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 24)
                    
                
                if habitStore.habits.isEmpty {
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
                } else {
                    List {
                        ForEach(habitStore.habits) { habit in
                            HabitCard(habit: habit, onComplete: {
                                habitStore.completeHabit(habit)
                            })
                                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 6, trailing: 16))
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        if let index = habitStore.habits.firstIndex(where: { $0.id == habit.id }) {
                                            habitStore.delete(at: IndexSet([index]))
                                        }
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                    .tint(.red)
                                
                                
                                }
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    Button {
                                        editingHabit = habit
                                        showEditSheet = true
                                    } label: {
                                        Image(systemName: "pencil")
                                    }
                                    .tint(.blue)
                                }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color(hex: 0x080808))
                    .scrollContentBackground(.hidden)
                }
            }
            .sheet(isPresented: $showEditSheet, onDismiss: {
                editingHabit = nil
            }) {
                if let habit = editingHabit {
                    NavigationView {
                        EditView(habit: habit)
                            .navigationBarTitle("Edit Habit", displayMode: .inline)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Button("Cancel") {
                                        showEditSheet = false
                                    }
                                    .foregroundColor(.white)
                                }
                            }
                    }
                    .environmentObject(habitStore)
                }
            }
        }
    }
}

struct HeaderView: View {
    @State private var createScreen = false
    @EnvironmentObject var habitStore: HabitStore
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 17)]
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
            
            Text(dateFormatter.string(from: Date()))
                .font(.system(size: 18))
                .fontWeight(.bold)
                .foregroundColor(.white)
            
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
            .environmentObject(habitStore)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
