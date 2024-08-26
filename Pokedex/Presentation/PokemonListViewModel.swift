//
//  PokemonListViewModel.swift
//  Pokedex
//
//  Created by Francisco Garcia on 22/08/24.
//

import SwiftUI

class PokemonListViewModel: ObservableObject {
    @Published var pokemonList = [Pokemon]()
    @Published var isLoading = false
    @Published var error: Error?

    internal var allPokemon = [Pokemon]()
    private let useCase = PokemonUseCase()
    private var offset = 0
    private var isSearching = false

    func fetchPokemonList(offset: Int) {
        guard !isLoading else { return }
        isLoading = true
        useCase.getPokemonList(offset: offset) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let pokemons):
                    self.allPokemon.append(contentsOf: pokemons)
                    self.pokemonList.append(contentsOf: pokemons)
                    self.pokemonList.sort(by: { $0.id < $1.id })
                case .failure(let error):
                    self.error = error
                }
            }
        }
    }
    
    func fetchMorePokemon() {
        guard !isLoading && !isSearching else { return }
        offset += 20
        fetchPokemonList(offset: offset)
    }

    func searchPokemon(by query: String) {
        isSearching = !query.isEmpty
        if query.isEmpty {
            pokemonList = allPokemon.sorted(by: { $0.id < $1.id })
        } else if let pokemonNumber = Int(query) {
            if let pokemon = allPokemon.first(where: { $0.id == pokemonNumber }) {
                pokemonList = [pokemon]
            } else {
                pokemonList = []
            }
        } else {
            pokemonList = allPokemon.filter { $0.name.lowercased().contains(query.lowercased()) }
            pokemonList.sort(by: { $0.id < $1.id })
        }
    }

    func stopSearching() {
        isSearching = false
        pokemonList = allPokemon.sorted(by: { $0.id < $1.id })
        offset = pokemonList.count
    }

    func filterPokemon(by type: String) {
        isSearching = type != "All"
        if type == "All" {
            pokemonList = allPokemon.sorted(by: { $0.id < $1.id })
        } else {
            pokemonList = allPokemon.filter { pokemon in
                pokemon.types.contains { $0.type.name.lowercased() == type.lowercased() }
            }
            pokemonList.sort(by: { $0.id < $1.id })
        }
    }
}
