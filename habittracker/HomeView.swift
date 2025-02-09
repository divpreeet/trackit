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
                Image(systemName: "flame.fill")
                    .foregroundColor(.white)
                Text("1 day")
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Button(action: {
                print("added habit")
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
