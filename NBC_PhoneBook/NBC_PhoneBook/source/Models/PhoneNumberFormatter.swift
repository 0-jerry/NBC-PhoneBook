//
//  MobilePhoneNumber.swift
//  NBC_PhoneBook
//
//  Created by t2023-m0072 on 12/9/24.
//
import Foundation

/// 핸드폰 번호 포맷터 (적용방식 수정 필요)
struct PhoneNumberFormatter {
    
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
