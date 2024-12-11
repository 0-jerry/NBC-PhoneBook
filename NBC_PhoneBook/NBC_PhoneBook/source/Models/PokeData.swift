//
//  PokeDataManager.swift
//  NBC_PhoneBook
//
//  Created by t2023-m0072 on 12/9/24.
//

import Foundation

struct PokeData {
    
    private let number: Int
    
    var pngURL: URL? {
        let url = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(self.number).png"
         
        return URL(string: url)
    }
    
    /// Cora Data 에서 불러올 때 사용
    init(from number: Int) {
        switch number {
        case 1...1000:
            self.number = number
        default:
            self.number = 132
        }
    }
    
    static func random() -> Self {
        let randomNumber = (1...1000).randomElement() ?? 132
        return PokeData(from: randomNumber)
    }
    /// 랜덤 생성
    
}
