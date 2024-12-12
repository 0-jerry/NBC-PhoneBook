//
//  PokeDataManager.swift
//  NBC_PhoneBook
//
//  Created by t2023-m0072 on 12/9/24.
//

import Foundation

struct PokeData {
    
    // 포켓몬 번호
    private let number: Int
    
    // 번호를 통해 URL 생성
    private var pngURL: URL? {
        let url = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(self.number).png"
        return URL(string: url)
    }
    
    /// 랜덤 URL 생성 시 사용
    private init(from number: Int) {
        switch number {
        case 1...1000:
            self.number = number
        default:
            self.number = 132
        }
    }
    
    /// 랜덤 이미지 URL
    static func randomURL() -> URL? {
        let randomNumber = Int.random(in: 1...1000)
        return PokeData(from: randomNumber).pngURL
    }
    
    /// 기본 이미지 URL
    static func dafaultURL() -> URL? {
        return PokeData(from: 132).pngURL
    }
    
}



