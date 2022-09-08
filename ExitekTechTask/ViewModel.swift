//
//  ViewModel.swift
//  ExitekTechTask
//
//  Created by Данила on 08.09.2022.
//

import Foundation
import CoreData
import UIKit


protocol MobileStorage {
    func getAll() -> Set<Mobile>
    func findByImei(_ imei: String) -> Mobile?
    func save(_ mobile: Mobile)throws -> Mobile
    func delete(_ product: Mobile)throws
    func exists(_ product: Mobile) -> Bool
}

//struct Mobile: Hashable {
//    let imei: String
//    let model: String
//}

class ViewModel: MobileStorage {
    
    var mobiles = [Mobile]()
    
    let context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        return context
    }()
    
    
    func start() {
        
        let fetchRequest: NSFetchRequest<Mobile> = Mobile.fetchRequest()
        
        do {
            mobiles = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func getAll() -> Set<Mobile> {
        
        var set = Set<Mobile>()
        var imeiArr = [String]()
        for mobile in mobiles {
            if imeiArr.first(where: {$0 == mobile.imei}) == nil {
                if mobile.imei != nil {
                    imeiArr.append(mobile.imei!)
                    set.insert(mobile)
                }
            }
        }
        
        return set
    }
    
    func findByImei(_ imei: String) -> Mobile? {
        if let item = mobiles.first(where: { $0.imei == imei}) {
            return item
        }
        return nil
    }
    
    enum ImeiValid: Error {
        case itsNotImei
        case imeiExists
    }
    
    func save(_ mobile: Mobile) throws -> Mobile {
        
        if findByImei(mobile.imei!) != nil { throw ImeiValid.imeiExists }
        if mobile.imei!.count != 15 || mobile.model == "" { throw ImeiValid.itsNotImei }
        
        do {
            try context.save()
            mobiles.append(mobile)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return mobile
    }
    
    enum DeleteMobile: Error {
        case notDeleted
    }
    
    func delete(_ product: Mobile) throws {
                
        do {
            context.delete(product)
            let mobCount = mobiles.count
            mobiles = mobiles.filter {$0.imei != product.imei}
            if mobCount == mobiles.count { throw DeleteMobile.notDeleted }
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func exists(_ product: Mobile) -> Bool {

        if  mobiles.first(where: {$0.imei == product.imei}) != nil &&
                mobiles.first(where: {$0.model == product.model}) != nil {
            return true
        }
        return false
    }
    
    enum Action {
        case save
        case delete
        case exists
    }
    
    func action(_ action: Action,_ imei: String,_ model: String) -> Bool {
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Mobile", in: context) else { return false }
        
        let mobile = Mobile(entity: entity , insertInto: context)
        mobile.imei = imei
        mobile.model = model

        switch action {
        case .save:
            do {
                let _ = try save(mobile)
                return true
            } catch {
                return false
            }
        case .delete:
            do {
                try delete(mobile)
                return true
            } catch {
                return false
            }
        case .exists:
            return exists(mobile)

        }
    }
}
