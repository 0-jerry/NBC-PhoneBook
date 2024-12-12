//
//  Poke.swift
//  NBC_PhoneBook
//
//  Created by t2023-m0072 on 12/8/24.
//

import Foundation

//https://pokeapi.co/

struct PokeAPI: Codable {
    
    private var id: Int?
    private var name: String?
    private var height: Int?
    private var weight: Int?
    private var sprites: Sprites?
    
    init?(from data: Data) {
        let jsonDecoder = JSONDecoder()
        guard let poke = try? jsonDecoder.decode(PokeAPI.self, from: data) else { return nil }
        self = poke
    }
    
    func frontDefaultURL() -> URL? {
        return sprites?.url()
    }

}

struct Sprites: Codable {
    
    private var frontDefault: String?
    
    func url() -> URL? {
        guard let urlString = self.frontDefault else { return nil }
        return URL(string: urlString)
    }
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
