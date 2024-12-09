//
//  PhoneBook.swift
//  NBC_PhoneBook
//
//  Created by t2023-m0072 on 12/8/24.
//

import Foundation

struct PokePhoneNumber {
    
    let id: UUID
    let pokeImage: Data
    let name: String
    let phoneNumber: String
    
    static let mockDatas: [PokePhoneNumber] = [].compactMap { $0 }
    
    init(id: UUID = UUID(), pokeImage: Data, name: String, phoneNumber: String) {
        self.id = id
        self.pokeImage = pokeImage
        self.name = name
        self.phoneNumber = phoneNumber
    }
    
}


