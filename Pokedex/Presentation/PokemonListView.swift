//
//  File.swiftPokemonListView.swift
//  Pokedex
//
//  Created by Francisco Garcia on 22/08/24.
//

import SwiftUI
import Kingfisher
import AVFoundation

struct PokemonListView: View {
    @StateObject private var viewModel = PokemonListViewModel()
    @State private var searchText = ""
    @State private var selectedType: String = "All"
    @State private var selectedTypeFromDetail: String?
    
    let pokemonTypes = ["All", "Fire", "Water", "Grass", "Electric", "Flying", "Poison", "Ground", "Rock", "Bug", "Ghost", "Steel", "Fighting", "Psychic", "Ice", "Dragon", "Dark", "Fairy"]
    
    @State private var backgroundAudioPlayer: AVAudioPlayer?

    var body: some View {
        NavigationView {
            VStack {
                
                TextField("Buscar por nombre o número...", text: $searchText, onCommit: {
                    viewModel.searchPokemon(by: searchText)
                })
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
                .foregroundColor(.white)
                .onChange(of: searchText) { newValue in
                    if newValue.isEmpty {
                        viewModel.stopSearching()
                    }
                }

                Picker("Filtrar por Tipo", selection: $selectedType) {
                    ForEach(pokemonTypes, id: \.self) {
                        Text($0).foregroundColor(.black)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(.horizontal)
                .onChange(of: selectedType) { newValue in
                    if searchText.isEmpty {
                        viewModel.filterPokemon(by: newValue)
                    }
                }

                List(viewModel.pokemonList) { pokemon in
                    NavigationLink(
                        destination: PokemonDetailView(
                            pokemon: pokemon,
                            onTypeSelected: { type in
                                selectedTypeFromDetail = type
                            }
                        )
                        .onAppear {
                            stopBackgroundMusic()
                        }
                    ) {
                        HStack {
                            KFImage(URL(string: pokemon.sprites.frontDefault))
                                .resizable()
                                .frame(width: 50, height: 50)
                            Text(pokemon.name.capitalized)
                                .foregroundColor(.white)
                        }
                    }
                    .onAppear {
                        if pokemon == viewModel.pokemonList.last && searchText.isEmpty && selectedType == "All" {
                            viewModel.fetchMorePokemon()
                        }
                    }
                }
                .background(Color.black.edgesIgnoringSafeArea(.all))
                .navigationTitle("Lista de Pokémon")
                .foregroundColor(.white)
                .onAppear {
                    if viewModel.pokemonList.isEmpty {
                        viewModel.fetchPokemonList(offset: 0)
                    }
                    if let type = selectedTypeFromDetail {
                        selectedType = type
                        viewModel.filterPokemon(by: type)
                        selectedTypeFromDetail = nil
                    }
                    playBackgroundMusic()
                }
                .onDisappear {
                    stopBackgroundMusic()
                }
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }
    
    func playBackgroundMusic() {
        if let path = Bundle.main.path(forResource: "1-01. Opening", ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                backgroundAudioPlayer = try AVAudioPlayer(contentsOf: url)
                backgroundAudioPlayer?.numberOfLoops = -1
                backgroundAudioPlayer?.play()
            } catch {
                print("Error al reproducir el audio: \(error)")
            }
        }
    }
    
    func stopBackgroundMusic() {
        backgroundAudioPlayer?.stop()
    }
}
