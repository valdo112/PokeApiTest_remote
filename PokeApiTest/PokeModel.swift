//
//  PokeModel.swift
//  PokeApiTest
//
//  Created by Valdo Parlinggoman on 12/07/23.
//

import Foundation

struct PokeModel: Codable{
    var results: [SubPokeModel] = []
}
struct SubPokeModel: Codable{
    var name: String
    var url: String
//    var ability: Ability
}

struct DetailPokemon: Codable {
    var abilities: [Ability]
    var sprites: PokemonSprites
    var types: [TypeDetails]
    var weight: Int
    var height: Int
    var moves: [Move]
    var stats: [Stat]
}

struct Stat: Codable{
    var base_stat: Int
    var effort: Int
    var stat: DetailAbility

}

struct Move: Codable{
    var move: DetailAbility
}

struct Ability: Codable {
    var ability: DetailAbility
}

struct DetailAbility: Codable {
    var name: String
    var url: String
}



struct PokemonSprites: Codable{
    var frontShiny: String
    var frontDefault: String
    
    enum CodingKeys: String, CodingKey{
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
    }
}

struct TypeDetails: Codable{
    var slot: Int
    var type: DetailAbility
}


