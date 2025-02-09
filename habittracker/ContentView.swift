import SwiftUI

struct ContentView: View {
    @AppStorage("userLogin") private var userLogin = false

    var body: some View {
        if userLogin {
            HomeView()
        } else {
            LoginView()
        }
    }
}


extension Color {
    init(hex: Int, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
