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
    
    static let mockDatas: [PokePhoneNumber] = {
        var mock: [PokePhoneNumber] = []
        
        (0...9).forEach {
            if let pngURL = PokeData(from: $0).pngURL,
               let data = try? Data(contentsOf: pngURL) {
                let phoneNumber = MobilePhoneNumber("010" + String(repeating: "\($0)", count: 8)).form()
                let pokePhoneNumber = PokePhoneNumber(pokeImage: data,
                                                      name: "이재영 \($0)",
                                                      phoneNumber: phoneNumber)
                
                mock.append(pokePhoneNumber)
            }
        }
        
        return mock
    }()
    
    init(id: UUID = UUID(), pokeImage: Data, name: String, phoneNumber: String) {
        self.id = id
        self.pokeImage = pokeImage
        self.name = name
        self.phoneNumber = phoneNumber
    }
    
}


