//
//  PokeContactManager.swift
//  NBC_PhoneBook
//
//  Created by t2023-m0072 on 12/8/24.
//

import UIKit

import CoreData

/// PokeContact에 대한 CRUD 메서드 지원
///
/// - Singleton
///
/// - CoreData
///
class PokeContactManager {
    
    private let container: NSPersistentContainer
    private let entity: NSEntityDescription?
    
    static let shared = PokeContactManager()
    
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let container = appDelegate.persistentContainer
        
        self.container = container
        self.entity = NSEntityDescription.entity(forEntityName: PokeContactData.className,
                                                 in: self.container.viewContext)
    }
    
    // 데이터 생성 메서드
    func creat(_ pokeContact: PokeContact) throws {
        setPokeContact(from: pokeContact)
        
        try save()
    }
    
    // 데이터 불러오기 메서드
    func read() throws -> [PokeContact] {
        let pokeContactDatas = try pokeContactDatas()
        
        let pokeContacts = pokeContactDatas.compactMap { $0.convertTo() }
        
        return pokeContacts
    }
    
    // 데이터 업데이트 메서드
    func update(_ pokeContact: PokeContact) throws {
        let pokeContactDatas = try pokeContactDatas()
        
        pokeContactDatas.forEach { $0.update(pokeContact) }
        
        try save()
    }
    
    // 데이터 삭제 메서드
    func delete(_ pokeContact: PokeContact) throws {
        let pokeContactDatas = try pokeContactDatas()
        
        pokeContactDatas.forEach {
            if $0.isSame(pokeContact) { container.viewContext.delete($0) }
        }
        
        try save()
    }
    
    // 전체 데이터 삭제 메서드
    func reset() throws {
        let pokeContactDatas = try pokeContactDatas()
        
        pokeContactDatas.forEach { container.viewContext.delete($0) }
        
        try save()
    }
}

//MARK: - 내부 사용 메서드

extension PokeContactManager {
    
    // 현재 데이터 저장
    private func save() throws {
        try self.container.viewContext.save()
    }
    
    // PhoneNumberData 객체 생성 및 데이터 저장
    private func setPokeContact(from phoneNumber: PokeContact) {
        guard let entity,
        let pokeContactData = NSManagedObject(entity: entity,
                                              insertInto: self.container.viewContext)
        as? PokeContactData else { return }
        
        pokeContactData.setPokeContactData(phoneNumber)
    }
    
    // 전체 데이터 불러오기
    private func pokeContactDatas() throws -> [PokeContactData] {
        return try self.container.viewContext.fetch(PokeContactData.fetchRequest())
    }
}
