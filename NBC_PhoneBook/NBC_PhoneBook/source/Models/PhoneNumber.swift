//
//  PhoneBook.swift
//  NBC_PhoneBook
//
//  Created by t2023-m0072 on 12/8/24.
//

import Foundation

struct PhoneNumber {
    
    let id: UUID
    let pokeImage: Data
    let name: String
    let number: String
    
    init(id: UUID, pokeImage: Data, name: String, number: String) {
        self.id = id
        self.pokeImage = pokeImage
        self.name = name
        self.number = number
    }
    
}


