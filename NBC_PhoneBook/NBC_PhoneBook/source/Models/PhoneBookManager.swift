//
//  PhoneBookManager.swift
//  NBC_PhoneBook
//
//  Created by t2023-m0072 on 12/8/24.
//

import UIKit

import CoreData

/// PhoneNumber에 대한 CRUD 메서드 지원
///
/// - Singleton
///
/// - CoreData
///
class PhoneBookManager {
    
    private let container: NSPersistentContainer
    private let entity: NSEntityDescription?
    
    static let shared = PhoneBookManager()
    
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let container = appDelegate.persistentContainer
        self.container = container
        self.entity = NSEntityDescription.entity(forEntityName: PhoneNumberData.className,
                                                 in: self.container.viewContext)
    }
    
    // 데이터 생성 메서드
    func creat(_ phoneNumber: PhoneNumber) throws {
        setPhoneNumber(from: phoneNumber)
        try save()
    }
    
    // 데이터 불러오기 메서드
    func read() throws -> [PhoneNumber] {
        let phoneNumberDatas = try phoneNumberDatas()
        let phoneNumbers = phoneNumberDatas.compactMap { $0.convertTo() }
        return phoneNumbers
    }
    
    // 데이터 업데이트 메서드
    func update(_ phoneNumber: PhoneNumber) throws {
        let phoneNumberDatas = try phoneNumberDatas()
        phoneNumberDatas.forEach { $0.update(phoneNumber) }
        try save()
    }
    
    // 데이터 삭제 메서드
    func delete(_ phoneNumber: PhoneNumber) throws {
        let phoneNumberDatas = try phoneNumberDatas()
        phoneNumberDatas.forEach {
            if $0.isSame(phoneNumber) {
                container.viewContext.delete($0)
            }
        }
        try save()
    }
    
    // 전체 데이터 삭제 메서드
    func reset() throws {
        let phoneNumberDatas = try phoneNumberDatas()
        phoneNumberDatas.forEach { container.viewContext.delete($0) }
        try save()
    }
}

//MARK: - 내부 사용 메서드

extension PhoneBookManager {
    
    // 현재 데이터 저장
    private func save() throws {
        try self.container.viewContext.save()
    }
    
    // PhoneNumberData 객체 생성 및 데이터 저장
    private func setPhoneNumber(from phoneNumber: PhoneNumber) {
        guard let entity else { return  }
        let object = NSManagedObject(entity: entity, insertInto: self.container.viewContext)
        
        guard let phoneNumberData = object as? PhoneNumberData else { return  }
        phoneNumberData.setPhoneNumber(phoneNumber)
    }
    
    // 전체 데이터 불러오기
    private func phoneNumberDatas() throws -> [PhoneNumberData] {
        return try self.container.viewContext.fetch(PhoneNumberData.fetchRequest())
    }
}
