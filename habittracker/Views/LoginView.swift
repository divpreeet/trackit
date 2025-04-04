import SwiftUI

struct LoginView: View {

    @AppStorage("userLogin") private var userLogin = false

    var body: some View {
        ZStack{
            Color(hex:0x080808)
                .edgesIgnoringSafeArea(.all)
            VStack{
                // i love za stacks
                VStack{
                    Text("trackit")
                        .font(.system(size: 70 ))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        
                    Text("your all in one habit tracking buddy")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)

                }
                .padding(.top, 125.0)


                Spacer()

                // Za Buttons for za login
                VStack{
                    Button(action:{
                        print("Hello world")
                    }, label:{
                        Label("continue with apple", systemImage: "apple.logo")
                    })
                    .fontWeight(.bold)
                    .frame(width: 300.0, height: 35.0)
                    .font(.system(size: 17))
                    .background(.black)
                    .foregroundColor(.white)
                    .cornerRadius(8.0)
                    
                    

                    // svgl is too good
                    Button(action:{
                        print("hello")
                    }, label:{
                        HStack{
                            Image("google")
                            .resizable()
                            .frame(width:16.0, height:16.0)

                            Text("continue with google")
                        }
                    })
                    .frame(width: 300.0, height: 35.0)
                    .font(.system(size: 17))
                    .fontWeight(.bold)
                    .background(.white)
                    .foregroundColor(.black)
                    .cornerRadius(8.0)
                    

                    Button("continue as guest") {
                            userLogin = true
                        }
                    .frame(width: 300.0, height: 35.0)
                    .font(.system(size: 17))
                    .fontWeight(.bold)
                    .background(Color(hex:0x424040))
                    .foregroundColor(.white)
                    .cornerRadius(8.0)
                    }
                    .padding(.bottom, 100.0)
            
            }

        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
