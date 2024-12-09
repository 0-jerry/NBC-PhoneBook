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
        guard let entity = self.entity,
              let pokePhoneNumberData = NSManagedObject(entity: entity,
                                                        insertInto: self.container.viewContext) as? PokePhoneNumberData else { return }
        
        pokePhoneNumberData.setPokePhoneNumber(pokePhoneNumber)
        
        do {
            try save()
        } catch let error {
            print("creat: error - \(error.localizedDescription)")
        }
        
    }
    
    func read() -> [PokePhoneNumber]? {
        var pokePhoneNumbers: [PokePhoneNumber] = []
        
        do {
            let pokePhoneNumberDatas = try self.container.viewContext.fetch(PokePhoneNumberData.fetchRequest())
            pokePhoneNumbers = pokePhoneNumberDatas.compactMap { $0.pokePhoneNumber() }
            
        } catch let error {
            print(error)
        }
        
        return !pokePhoneNumbers.isEmpty ? pokePhoneNumbers : nil
    }
    
    func update(_ pokePhoneNumber: PokePhoneNumber) {
        do {
            let pokePhoneNumberDatas = try self.container.viewContext.fetch(PokePhoneNumberData.fetchRequest())
            pokePhoneNumberDatas.forEach {
                $0.update(pokePhoneNumber)
            }
            
            try save()
            
        } catch let error {
            print(error)
        }
    }
    
    func delete(_ pokePhoneNumber: PokePhoneNumber) {
        do {
            let pokePhoneNumberDatas = try self.container.viewContext.fetch(PokePhoneNumberData.fetchRequest())
            pokePhoneNumberDatas.forEach {
                if $0.isSame(pokePhoneNumber) {
                    container.viewContext.delete($0)
                }
            }
            
            try save()
            
        } catch let error {
            print(error)
        }
    }
    
    
    private func save() throws {
        try self.container.viewContext.save()
    }
}
