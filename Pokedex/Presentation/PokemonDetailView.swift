//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by Francisco Garcia on 22/08/24.
//

import SwiftUI
import Kingfisher
import AVFoundation

struct PokemonDetailView: View {
    let pokemon: Pokemon
    @State var detailAudioPlayer: AVAudioPlayer?
    let onTypeSelected: (String) -> Void
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                KFImage(URL(string: pokemon.sprites.frontDefault))
                    .resizable()
                    .frame(width: 100, height: 100)
                
                KFImage(URL(string: pokemon.sprites.frontShiny))
                    .resizable()
                    .frame(width: 100, height: 100)
            }
            
            Text(pokemon.name.capitalized)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            HStack(spacing: 8) {
                ForEach(pokemon.types, id: \.type.name) { type in
                    Text(type.type.name.capitalized)
                        .padding(8)
                        .background(typeColor(for: type.type.name))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .onTapGesture {
                            onTypeSelected(type.type.name)
                            presentationMode.wrappedValue.dismiss()
                        }
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(pokemon.stats, id: \.stat.name) { stat in
                    Text("\(stat.stat.name.capitalized): \(stat.baseStat)")
                        .font(.headline)
                }
            }
            .padding(.top, 16)
            
            Spacer()
        }
        .navigationTitle("Detalles del Pokémon")
        .padding()
        .onAppear() {
            playDetailMusic()
        }
        .onDisappear {
            stopDetailMusic()
        }
    }
    
    func playDetailMusic() {
        if let path = Bundle.main.path(forResource: "1-15. Battle (Vs. Trainer)", ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                detailAudioPlayer = try AVAudioPlayer(contentsOf: url)
                detailAudioPlayer?.numberOfLoops = -1
                detailAudioPlayer?.play()
            } catch {
                print("Error al reproducir el audio: \(error)")
            }
        }
    }
    
    func stopDetailMusic() {
        detailAudioPlayer?.stop()
    }
        
    func typeColor(for typeName: String) -> Color {
        switch typeName.lowercased() {
        case "fire": return .red
        case "water": return .blue
        case "grass": return .green
        case "electric": return .yellow
        case "flying": return .purple
        case "poison": return .purple
        case "ground": return .brown
        case "rock": return .gray
        case "bug": return .green
        case "ghost": return .purple
        case "steel": return .gray
        case "fighting": return .orange
        case "psychic": return .pink
        case "ice": return .cyan
        case "dragon": return .indigo
        case "dark": return .black
        case "fairy": return .pink
        default: return .gray
        }
    }
}
