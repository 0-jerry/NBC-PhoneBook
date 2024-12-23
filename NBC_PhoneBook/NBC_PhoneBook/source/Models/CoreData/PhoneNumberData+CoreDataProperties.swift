//
//  PhoneNumberData+CoreDataProperties.swift
//  NBC_PhoneBook
//
//  Created by t2023-m0072 on 12/11/24.
//
//

import Foundation

import CoreData

extension PhoneNumberData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhoneNumberData> {
        return NSFetchRequest<PhoneNumberData>(entityName: "PhoneNumberData")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var number: String?
    @NSManaged public var imageURL: URL?

    static let className: String = "PhoneNumberData"
    
    enum Key {
        static let id = "id"
        static let imageURL = "imageURL"
        static let name = "name"
        static let number = "number"
    }
    
    // 데이터를 입력받아 값을 설정해주는 메서드
    func setPhoneNumber(_ phoneNumber: PhoneNumber) {
        self.setValue(phoneNumber.id, forKey: PhoneNumberData.Key.id)
        self.setValue(phoneNumber.imageURL, forKey: PhoneNumberData.Key.imageURL)
        self.setValue(phoneNumber.name, forKey: PhoneNumberData.Key.name)
        self.setValue(phoneNumber.number, forKey: PhoneNumberData.Key.number)
    }
    
    // 사용 데이터 형태로 반환
    func convertTo() -> PhoneNumber? {
        guard let id,
              let imageURL,
              let name,
              let number else { return nil}
        
        return PhoneNumber(id: id,
                           imageURL: imageURL,
                           name: name,
                           number: number)
    }
    
    // 데이터 업데이트
    func update(_ phoneNumber: PhoneNumber) {
        guard isSame(phoneNumber) else { return }
        setPhoneNumber(phoneNumber)
    }
    
    // id를 통한 검증 메서드
    func isSame(_ phoneNumber: PhoneNumber) -> Bool {
        return id == phoneNumber.id
    }
    
}

extension PhoneNumberData : Identifiable {

}
