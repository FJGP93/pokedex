//
//  PokemonService.swift
//  Pokedex
//
//  Created by Francisco Garcia on 21/08/24.
//

import Alamofire
import Dispatch

class PokemonService {
    private let baseURL = "https://pokeapi.co/api/v2"

    func fetchPokemonList(offset: Int, completion: @escaping (Result<[Pokemon], Error>) -> Void) {
        let url = "\(baseURL)/pokemon?offset=\(offset)&limit=20"
        
        AF.request(url).responseDecodable(of: PokemonListResponse.self) { response in
            switch response.result {
            case .success(let result):
                var pokemonDetailsList = [Pokemon]()
                let dispatchGroup = DispatchGroup()
                
                for pokemonItem in result.results {
                    dispatchGroup.enter()
                    self.fetchPokemonDetails(url: pokemonItem.url) { result in
                        switch result {
                        case .success(let pokemon):
                            pokemonDetailsList.append(pokemon)
                        case .failure(let error):
                            print("Error al consultar detalles: \(error)")
                        }
                        dispatchGroup.leave()
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    completion(.success(pokemonDetailsList))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchPokemonDetails(url: String, completion: @escaping (Result<Pokemon, Error>) -> Void) {
        AF.request(url).responseDecodable(of: Pokemon.self) { response in
            switch response.result {
            case .success(let pokemon):
                completion(.success(pokemon))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

struct PokemonListResponse: Codable {
    let results: [PokemonListItem]
}

struct PokemonListItem: Codable {
    let name: String
    let url: String
}
