//
//  JSONCodable.swift
//  NBC_PhoneBook
//
//  Created by t2023-m0072 on 12/8/24.
//

import Foundation

/// JSONCodable
protocol JSONCodable: Codable {
    
}

extension JSONCodable {
    
    /// JSON 형식으로 인코딩
    func json() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
    /// JSON 형식의 데이터를 디코딩
    init?(from data: Data) {
        guard let value = try? JSONDecoder().decode(Self.self, from: data) else { return nil }
        self = value
    }
    
}
