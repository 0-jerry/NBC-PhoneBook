//
//  PhoneBook.swift
//  NBC_PhoneBook
//
//  Created by t2023-m0072 on 12/8/24.
//

import Foundation

struct PhoneNumber {
    
    let pokeNumber: Int
    
    let name: String
    
    let phoneNumber: String
    
    static let mockDatas: [PhoneNumber] = [PhoneNumber(pokeNumber: 1,
                                                       name: "이재영",
                                                       phoneNumber: "010-1234-1234"),
                                           PhoneNumber(pokeNumber: 2,
                                                       name: "이재영이재영",
                                                       phoneNumber: "010-0000-0000"),
                                           PhoneNumber(pokeNumber: 3,
                                                       name: "이재영이재영이재영이재영",
                                                       phoneNumber: "010-1234-1234"),
                                           PhoneNumber(pokeNumber: 4,
                                                       name: "이재영이재영",
                                                       phoneNumber: "010-0000-0000"),
                                           PhoneNumber(pokeNumber: 5,
                                                       name: "jae",
                                                       phoneNumber: "010-1234-1234"),
                                           PhoneNumber(pokeNumber: 6,
                                                       name: "young",
                                                       phoneNumber: "010-0000-0000"),
                                           PhoneNumber(pokeNumber: 7,
                                                       name: "jae",
                                                       phoneNumber: "010-1234-1234"),
                                           PhoneNumber(pokeNumber: 8,
                                                       name: "young",
                                                       phoneNumber: "010-0000-0000")]
    
}
