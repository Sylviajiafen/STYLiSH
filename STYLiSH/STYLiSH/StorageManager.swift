//
//  StorageManager.swift
//  STYLiSH
//
//  Created by Sylvia Jia Fen  on 2019/7/26.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import Foundation
import CoreData

class StorageManager {
    
    static let shared = StorageManager()  // Singleton
    
    // 建立資料容器
    lazy var persistentContainer: NSPersistentContainer = {
            
            let container = NSPersistentContainer(name: "STYLiSH")  // container 代表整個 STYLiSH.xcdatamodeld 檔案
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()
        
        var viewContext: NSManagedObjectContext {
            return persistentContainer.viewContext
        } // view context 是儲存、拿取資料的橋樑：save .fetch
    
    private init() {}
    
    func updateCoreData() {
        do {
            try StorageManager.shared.persistentContainer.viewContext.save() // 儲存進 SQLite
        } catch {
            fatalError()
        }
    }
    
//    func fetchFromCoreData() {
//        let fetchRequest =
//            NSFetchRequest<Cart>(entityName: "Cart")
//        
//        do {
//            CartViewController.cartData = try StorageManager.shared.persistentContainer.viewContext.fetch(fetchRequest)
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
//    }
    
//    private (set) var cartQuant: Int?
}

extension Notification.Name {
    static let didCreateCartList = Notification.Name("didCreateCartList")
    static let didUpdateCartList = Notification.Name("didUpdateCartList")
}
