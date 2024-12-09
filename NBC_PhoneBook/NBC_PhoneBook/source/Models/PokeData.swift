//
//  PokeDataManager.swift
//  NBC_PhoneBook
//
//  Created by t2023-m0072 on 12/9/24.
//

import Foundation

struct PokeData {
    
    private let number: Int
    
    private var pngURL: URL? {
        let url = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/\(self.number).png"
        
        return URL(string: url)
    }
    
    /// Cora Data 에서 불러올 때 사용
    init(from number: Int) {
        self.number = number
    }
    
    /// 랜덤 생성 
    init() {
        self.number = (1...1000).randomElement() ?? 132
    }
}
