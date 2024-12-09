//
//  PhoneBookManager.swift
//  NBC_PhoneBook
//
//  Created by t2023-m0072 on 12/8/24.
//

import Foundation

import CoreData

/// CRUD
class PhoneBookManager {
    
    private let container: NSPersistentContainer
    
    private lazy var entity = NSEntityDescription.entity(forEntityName: PokePhoneNumberData.className,
                                                    in: self.container.viewContext)
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
    
    func creat(_ pokePhoneNumber: PokePhoneNumber) {
        guard let entity = self.entity else { return }
        
        let pokePhoneNumberData = NSManagedObject(entity: entity,
                                                  insertInto: self.container.viewContext)
        
        pokePhoneNumberData.setValue(pokePhoneNumber.id,
                                     forKey: PokePhoneNumberData.Key.id)
        pokePhoneNumberData.setValue(pokePhoneNumber.name,
                                     forKey: PokePhoneNumberData.Key.name)
        pokePhoneNumberData.setValue(pokePhoneNumber.phoneNumber,
                                     forKey: PokePhoneNumberData.Key.number)
        pokePhoneNumberData.setValue(pokePhoneNumber.pokeImage,
                                     forKey: PokePhoneNumberData.Key.pokeImage)
        
        do {
            try save()
        } catch let error {
            print("creat: error - \(error.localizedDescription)")
        }
        
    }
    
    func read() -> [PokePhoneNumber]? {
        var pokePhoneNumbers: [PokePhoneNumber] = []
        
        return !pokePhoneNumbers.isEmpty ? pokePhoneNumbers : nil
    }
    
    func update(_ pokePhoneNumber: PokePhoneNumber) {
    
    }
    
    func delete(_ pokePhoneNumber: PokePhoneNumber) {
        
    }
    
    
    private func save() throws {
        try self.container.viewContext.save()
    }
}
