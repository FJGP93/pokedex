//
//  SplashView.swift
//  Pokedex
//
//  Created by Javier Garcia on 25/08/24.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false

    var body: some View {
        if isActive {
            PokemonListView()
        } else {
            VStack {
                Image("pokedex")
                    .resizable()
                    .frame(width: 280, height: 280)
                    .foregroundColor(.yellow)

                Text("Pokedex")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}
