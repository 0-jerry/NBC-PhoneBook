//
//  PokePhoneNumberData+CoreDataProperties.swift
//  NBC_PhoneBook
//
//  Created by t2023-m0072 on 12/9/24.
//
//

import Foundation
import CoreData


extension PokePhoneNumberData {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokePhoneNumberData> {
        return NSFetchRequest<PokePhoneNumberData>(entityName: "PokePhoneNumberData")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var pokeImage: Data?
    @NSManaged public var name: String?
    @NSManaged public var number: String?
    
    static let className: String = "PokePhoneNumberData"
    
    enum Key {
        static let id = "id"
        static let pokeImage = "pokeImage"
        static let name = "name"
        static let number = "number"
    }
    
    func setPokePhoneNumber(_ pokePhoneNumber: PokePhoneNumber) {
        self.setValue(pokePhoneNumber.id, forKey: PokePhoneNumberData.Key.id)
        self.setValue(pokePhoneNumber.name, forKey: PokePhoneNumberData.Key.name)
        self.setValue(pokePhoneNumber.phoneNumber, forKey: PokePhoneNumberData.Key.number)
        self.setValue(pokePhoneNumber.pokeImage, forKey: PokePhoneNumberData.Key.pokeImage)
    }
    
    func pokePhoneNumber() -> PokePhoneNumber? {
        guard let id,
              let pokeImage,
              let name,
              let number else { return nil}
        
        return PokePhoneNumber(id: id,
                               pokeImage: pokeImage,
                               name: name,
                               phoneNumber: number)
    }
    
    func update(_ pokePhoneNumber: PokePhoneNumber) {
        guard isSame(pokePhoneNumber) else { return }
        setPokePhoneNumber(pokePhoneNumber)
    }
    
    func isSame(_ pokePhoneNumber: PokePhoneNumber) -> Bool {
        return id == pokePhoneNumber.id
    }
}

extension PokePhoneNumberData : Identifiable {
    
}
