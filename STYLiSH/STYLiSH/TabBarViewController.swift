
//
//  TabBarViewController.swift
//  STYLiSH
//
//  Created by Sylvia Jia Fen  on 2019/7/27.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit
import CoreData

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self
            , selector: #selector(handleDidCreateCartList), name: .didCreateCartList, object: nil)
        
        fetchFromCoreData()
        self.viewControllers?[2].tabBarItem.badgeValue = String(CartViewController.cartData.count)
//        NotificationCenter.default.post(name: .didCreateCartList, object: self, userInfo: nil)
        print(CartViewController.cartData.count)
    }
    
    func fetchFromCoreData() {
        let fetchRequest =
            NSFetchRequest<Cart>(entityName: "Cart")
        
        do {
            CartViewController.cartData = try StorageManager.shared.persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    @objc func handleDidCreateCartList(notification: Notification) {
        self.viewControllers?[2].tabBarItem.badgeValue = String(CartViewController.cartData.count)
    }
    
}
