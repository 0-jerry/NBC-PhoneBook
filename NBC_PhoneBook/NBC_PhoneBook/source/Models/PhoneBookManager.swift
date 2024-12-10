//
//  PhoneBookManager.swift
//  NBC_PhoneBook
//
//  Created by t2023-m0072 on 12/8/24.
//

import UIKit

import CoreData

/// CRUD
class PhoneBookManager {
    
    static let shared = PhoneBookManager()
    
    private let container: NSPersistentContainer
    private let entity: NSEntityDescription?
    
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let container = appDelegate.persistentContainer
        self.container = container
        self.entity = NSEntityDescription.entity(forEntityName: PhoneNumberData.className,
                                                 in: self.container.viewContext)
    }
    
    func creat(_ phoneNumber: PhoneNumber) {
        make(by: phoneNumber)
        
        do {
            try save()
        } catch let error {
            print("creat: error - \(error.localizedDescription)")
        }
        
    }
    
    func read() -> [PhoneNumber]? {
        guard let phoneNumberDatas = phoneNumberDatas() else { return nil }
        let phoneNumbers = phoneNumberDatas.compactMap { $0.convertTo() }
        
        return phoneNumbers
    }
    
    func update(_ phoneNumber: PhoneNumber) {
        guard let phoneNumberDatas = phoneNumberDatas() else { return }
        phoneNumberDatas.forEach { $0.update(phoneNumber) }
        
        do {
            try save()
        } catch let error {
            print("update: error - \(error.localizedDescription)")
        }
    }
    
    func delete(_ phoneNumber: PhoneNumber) {
        guard let phoneNumberDatas = phoneNumberDatas() else { return }
        
        phoneNumberDatas.forEach {
            if $0.isSame(phoneNumber) { container.viewContext.delete($0) }
        }
        do {
            try save()
        } catch let error {
            print("delete: error - \(error.localizedDescription)")
        }
    }
    
    func reset() {
        guard let phoneNumberDatas = phoneNumberDatas() else { return }
        
        phoneNumberDatas.forEach {
            container.viewContext.delete($0)
        }
        do {
            try save()
        } catch let error {
            print("delete: error - \(error.localizedDescription)")
        }
    }
    
    
    private func save() throws {
        try self.container.viewContext.save()
    }
    
    private func make(by phoneNumber: PhoneNumber) {
        guard let entity else { return  }
        let object = NSManagedObject(entity: entity, insertInto: self.container.viewContext)
        
        guard let phoneNumberData = object as? PhoneNumberData else { return  }
        phoneNumberData.setPhoneNumber(phoneNumber)
    }
    
    private func phoneNumberDatas() -> [PhoneNumberData]? {
        return try? self.container.viewContext.fetch(PhoneNumberData.fetchRequest())
    }
}
