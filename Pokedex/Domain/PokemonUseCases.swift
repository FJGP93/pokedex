//
//  PokemonUseCases.swift
//  Pokedex
//
//  Created by Francisco Garcia on 22/08/24.
//

import Foundation

class PokemonUseCase {
    private let service = PokemonService()

    func getPokemonList(offset: Int, completion: @escaping (Result<[Pokemon], Error>) -> Void) {
        service.fetchPokemonList(offset: offset, completion: completion)
    }

    func getPokemonDetails(url: String, completion: @escaping (Result<Pokemon, Error>) -> Void) {
        service.fetchPokemonDetails(url: url, completion: completion)
    }
}
