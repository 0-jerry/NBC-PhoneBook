//
//  PokeContactData+CoreDataProperties.swift
//  NBC_PhoneBook
//
//  Created by t2023-m0072 on 12/12/24.
//
//

import Foundation

import CoreData

extension PokeContactData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokeContactData> {
        return NSFetchRequest<PokeContactData>(entityName: "PokeContactData")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var imageURL: URL?
    @NSManaged public var name: String?
    @NSManaged public var number: String?

    static let className: String = "PokeContactData"
    
    enum Key {
        static let id = "id"
        static let imageURL = "imageURL"
        static let name = "name"
        static let number = "number"
    }
    
    // 데이터를 입력받아 값을 설정해주는 메서드
    func setPokeContactData(_ pokeContact: PokeContact) {
        self.setValue(pokeContact.id, forKey: PokeContactData.Key.id)
        self.setValue(pokeContact.imageURL, forKey: PokeContactData.Key.imageURL)
        self.setValue(pokeContact.name, forKey: PokeContactData.Key.name)
        self.setValue(pokeContact.number, forKey: PokeContactData.Key.number)
    }
    
    // 사용 데이터 형태로 반환
    func convertTo() -> PokeContact? {
        guard let id,
              let imageURL,
              let name,
              let number else { return nil}
        
        return PokeContact(id: id,
                           imageURL: imageURL,
                           name: name,
                           number: number)
    }
    
    // 데이터 업데이트
    func update(_ pokeContact: PokeContact) {
        guard isSame(pokeContact) else { return }
        setPokeContactData(pokeContact)
    }
    
    // id를 통한 검증 메서드
    func isSame(_ pokeContact: PokeContact) -> Bool {
        return id == pokeContact.id
    }
}

extension PokeContactData : Identifiable {

}
