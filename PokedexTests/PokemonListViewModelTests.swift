//
//  PokemonListViewModelTests.swift
//  PokedexTests
//
//  Created by Javier Garcia on 26/08/24.
//

import XCTest
@testable import Pokedex

class PokemonListViewModelTests: XCTestCase {

    var viewModel: PokemonListViewModel!

    override func setUp() {
        super.setUp()
        viewModel = PokemonListViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testFetchPokemonList() {
        XCTAssertTrue(viewModel.pokemonList.isEmpty)

        let pokemon1 = Pokemon(id: 1, name: "Bulbasaur", sprites: Sprites(frontDefault: "", frontShiny: ""), types: [], stats: [])
        let pokemon2 = Pokemon(id: 2, name: "Ivysaur", sprites: Sprites(frontDefault: "", frontShiny: ""), types: [], stats: [])

        viewModel.pokemonList.append(contentsOf: [pokemon1, pokemon2])

        XCTAssertEqual(viewModel.pokemonList.count, 2)
        XCTAssertEqual(viewModel.pokemonList[0].name, "Bulbasaur")
    }

    func testSearchPokemonByName() {
        let pokemon1 = Pokemon(id: 1, name: "Bulbasaur", sprites: Sprites(frontDefault: "", frontShiny: ""), types: [], stats: [])
        let pokemon2 = Pokemon(id: 2, name: "Ivysaur", sprites: Sprites(frontDefault: "", frontShiny: ""), types: [], stats: [])

        viewModel.pokemonList.append(contentsOf: [pokemon1, pokemon2])
        viewModel.allPokemon.append(contentsOf: [pokemon1, pokemon2])

        viewModel.searchPokemon(by: "Ivysaur")
        
        XCTAssertEqual(viewModel.pokemonList.count, 1)
        XCTAssertEqual(viewModel.pokemonList[0].name, "Ivysaur")
    }

    func testFilterPokemonByType() {
        let fireType = PokemonType(type: TypeDetail(name: "fire"))
        let waterType = PokemonType(type: TypeDetail(name: "water"))

        let pokemon1 = Pokemon(id: 1, name: "Charmander", sprites: Sprites(frontDefault: "", frontShiny: ""), types: [fireType], stats: [])
        let pokemon2 = Pokemon(id: 2, name: "Squirtle", sprites: Sprites(frontDefault: "", frontShiny: ""), types: [waterType], stats: [])

        viewModel.pokemonList.append(contentsOf: [pokemon1, pokemon2])
        viewModel.allPokemon.append(contentsOf: [pokemon1, pokemon2])

        viewModel.filterPokemon(by: "fire")

        XCTAssertEqual(viewModel.pokemonList.count, 1)
        XCTAssertEqual(viewModel.pokemonList[0].name, "Charmander")
    }
}
