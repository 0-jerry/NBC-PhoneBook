//
//  PokePhoneNumberData+CoreDataProperties.swift
//  NBC_PhoneBook
//
//  Created by t2023-m0072 on 12/9/24.
//
//

import Foundation
import CoreData


extension PhoneNumberData {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhoneNumberData> {
        return NSFetchRequest<PhoneNumberData>(entityName: "PhoneNumberData")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var pokeImage: Data?
    @NSManaged public var name: String?
    @NSManaged public var number: String?
    
    static let className: String = "PhoneNumberData"
    
    enum Key {
        static let id = "id"
        static let pokeImage = "pokeImage"
        static let name = "name"
        static let number = "number"
    }
    
    func setPhoneNumber(_ phoneNumber: PhoneNumber) {
        self.setValue(phoneNumber.id, forKey: PhoneNumberData.Key.id)
        self.setValue(phoneNumber.pokeImage, forKey: PhoneNumberData.Key.pokeImage)
        self.setValue(phoneNumber.name, forKey: PhoneNumberData.Key.name)
        self.setValue(phoneNumber.phoneNumber, forKey: PhoneNumberData.Key.number)
    }
    
    func convertTo() -> PhoneNumber? {
        guard let id,
              let pokeImage,
              let name,
              let number else { return nil}
        
        return PhoneNumber(id: id,
                           pokeImage: pokeImage,
                           name: name,
                           number: number)
    }
    
    func update(_ phoneNumber: PhoneNumber) {
        guard isSame(phoneNumber) else { return }
        setPhoneNumber(phoneNumber)
    }
    
    func isSame(_ phoneNumber: PhoneNumber) -> Bool {
        return id == phoneNumber.id
    }
}

extension PhoneNumberData : Identifiable {
    
}
