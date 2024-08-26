//
//  Pokemon.swift
//  Pokedex
//
//  Created by Francisco Garcia on 21/08/24.
//

import Foundation

struct Pokemon: Identifiable, Codable, Equatable {
    
    let id: Int
    let name: String
    let sprites: Sprites
    let types: [PokemonType]
    let stats: [PokemonStat]
    
    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Sprites: Codable {
    let frontDefault: String
    let frontShiny: String

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
    }
}

struct PokemonType: Codable {
    let type: TypeDetail
}

struct TypeDetail: Codable {
    let name: String
}

struct PokemonStat: Codable {
    let stat: StatDetail
    let baseStat: Int

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}

struct StatDetail: Codable {
    let name: String
}
