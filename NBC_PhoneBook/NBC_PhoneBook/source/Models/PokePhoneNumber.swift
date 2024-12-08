//
//  PhoneBook.swift
//  NBC_PhoneBook
//
//  Created by t2023-m0072 on 12/8/24.
//

import Foundation

struct PokePhoneNumber {
    
    let pokeNumber: Int
    let name: String
    let phoneNumber: String
    
    static let mockDatas: [PokePhoneNumber] = [
        PokePhoneNumber(pokeNumber: 1,
                        name: "이재영",
                        phoneNumber: "010-1234-1234"),
        PokePhoneNumber(pokeNumber: 2,
                        name: "이재영이재영",
                        phoneNumber: "010-0000-0000"),
        PokePhoneNumber(pokeNumber: 3,
                        name: "이재영이재영이재영이재영",
                        phoneNumber: "010-1234-1234"),
        PokePhoneNumber(pokeNumber: 4,
                        name: "이재영이재영",
                        phoneNumber: "010-0000-0000"),
        PokePhoneNumber(pokeNumber: 5,
                        name: "jae",
                        phoneNumber: "010-1234-1234"),
        PokePhoneNumber(pokeNumber: 6,
                        name: "young",
                        phoneNumber: "010-0000-0000"),
        PokePhoneNumber(pokeNumber: 7,
                        name: "jae",
                        phoneNumber: "010-1234-1234"),
        PokePhoneNumber(pokeNumber: 8,
                        name: "young",
                        phoneNumber: "010-0000-0000")
    ]
    
    init(pokeNumber: Int, name: String, phoneNumber: String) {
        self.pokeNumber = pokeNumber
        self.name = name
        self.phoneNumber = MobilePhoneNumber(phoneNumber).form()
    }
    
}

/// 핸드폰 번호 입력
struct MobilePhoneNumber {
    
    private var firstNumber: String = ""
    private var centerNumber: String = ""
    private var lastNumber: String = ""
    
    init(_ str: String) {
        let str = str.filter { $0.isNumber }
        
        var firstNumber = ""
        var centerNumber = ""
        var lastNumber = ""
        
        for i in str.enumerated() {
            let char = i.element
            let index = i.offset
            
            switch index {
            case 0...2:
                firstNumber.append(char)
            case 3...6:
                centerNumber.append(char)
            default:
                lastNumber.append(char)
            }
            
            self.firstNumber = firstNumber
            self.centerNumber = centerNumber
            self.lastNumber = lastNumber
        }
    }
    
    func form(_ seperator: String = "-") -> String {
        [
            firstNumber,
            centerNumber,
            lastNumber
        ].filter { !$0.isEmpty }
            .joined(separator: seperator)
    }
    
    
}
