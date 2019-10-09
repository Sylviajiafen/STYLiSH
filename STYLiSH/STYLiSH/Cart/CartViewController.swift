//
//  CartViewController.swift
//  STYLiSH
//
//  Created by Sylvia Jia Fen  on 2019/7/25.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit
import Kingfisher
import CoreData

class CartViewController: UIViewController,
                          UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var cartTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        cartTableView.delegate = self
        cartTableView.dataSource = self
    }
    
    // 拿 core data 的資料
    static var cartData: [Cart] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFromCoreData()
        cartTableView.reloadData()
    }
    
    func fetchFromCoreData() {
        
        let fetchRequest =
            NSFetchRequest<Cart>(entityName: "Cart")
        
        do {
            CartViewController.cartData = try StorageManager.shared.persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        print("cartData⬇️")
        print(CartViewController.cartData)
    }
    
    // table view 頁面設置
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CartViewController.cartData.count
    }
    
    var currentTextValue: Int = 1
    
    // swiftlint:disable line_length
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cartCell = cartTableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath)
                            as? CartTableViewCell else {fatalError()}
        // 讓 cell 認識 VC
        cartCell.cartViewController = self
        
        // 購買資訊
        let cartImageString = CartViewController.cartData[indexPath.row].selectedImage
        let cartImageUrl = URL(string: cartImageString ?? "no image")
        cartCell.cartImage.kf.setImage(with: cartImageUrl)
        cartCell.cartProductName.text = CartViewController.cartData[indexPath.row].selectedName
        cartCell.cartProductPrice.text = "NT$ \(CartViewController.cartData[indexPath.row].selectedPrice)"
        cartCell.cartProductColor.backgroundColor = UIColor(hexString: CartViewController.cartData[indexPath.row].selectedColor ?? "no color")
        cartCell.cartProductSize.text = CartViewController.cartData[indexPath.row].selectedSize

        // 數量區塊初始設置
        cartCell.cartIncreaseBtn.layer.borderWidth = 0.8
        cartCell.cartIncreaseBtn.layer.borderColor = UIColor(red: 63/255, green: 63/255, blue: 58/255, alpha: 1).cgColor
        cartCell.cartDecreaseBtn.layer.borderWidth = 0.8
        cartCell.cartDecreaseBtn.layer.borderColor = UIColor(red: 63/255, green: 63/255, blue: 58/255, alpha: 1).cgColor
        cartCell.cartQuantText.layer.borderWidth = 0.6
        cartCell.cartQuantText.layer.borderColor = UIColor(red: 63/255, green: 63/255, blue: 58/255, alpha: 1).cgColor
        cartCell.cartQuantText.isEnabled = false
        
        if CartViewController.cartData[indexPath.row].selectedQuant == 1 {
            cartCell.cartDecreaseBtn.isEnabled = false
            cartCell.cartDecreaseBtn.alpha = 0.4
        }
        
        cartCell.quantity = Int(CartViewController.cartData[indexPath.row].selectedQuant) // 讓 quatity 要做更動的初始值為 selectedQuant
        cartCell.cartQuantText.text = String(CartViewController.cartData[indexPath.row].selectedQuant)
        print("-----")
        print(cartCell.quantity)
        print(cartCell.cartQuantText.text)
        
        cartCell.currentIndex = indexPath
        
        return cartCell
    }
    
    // swiftlint:disable line_length
    
    // 設置使用者按下按鈕後會觸發的 func
    func userDidHitQuanBtn(_ cell: CartTableViewCell) {
        
        guard let quantChangedIndexPath = cartTableView.indexPath(for: cell) else {return}
        
        CartViewController.cartData[quantChangedIndexPath.row].selectedQuant = Int16(cell.quantity)
        // 把加減後的數量丟回 table View 的資料 array 中的 selectedQuant
        
        if CartViewController.cartData[quantChangedIndexPath.row].selectedQuant == CartViewController.cartData[quantChangedIndexPath.row].selectedStock {
            cell.cartIncreaseBtn.isEnabled = false
            cell.cartIncreaseBtn.alpha = 0.4
        }
        
        if CartViewController.cartData[quantChangedIndexPath.row].selectedQuant == 1 {
            cell.cartDecreaseBtn.isEnabled = false
            cell.cartDecreaseBtn.alpha = 0.4
        }
        // 按下加減按鈕都會 save to coreData
        StorageManager.shared.updateCoreData()
        datas[quantChangedIndexPath.row] = true
    }
    
    func userDidRemoveSth(_ cell: CartTableViewCell) {
        guard let toBeRemovedBtnIndexPath = cartTableView.indexPath(for: cell) else {return}
        
        let cartObjectToBeRemoved = CartViewController.cartData[toBeRemovedBtnIndexPath.row]
        func deleteCoreData() {
                StorageManager.shared.persistentContainer.viewContext.delete(cartObjectToBeRemoved)
            }
        deleteCoreData()
        CartViewController.cartData.remove(at: toBeRemovedBtnIndexPath.row)
        cartTableView.deleteRows(at: [toBeRemovedBtnIndexPath], with: .fade)
        StorageManager.shared.updateCoreData()
        // Notice
        fetchFromCoreData()
        NotificationCenter.default.post(name: .didCreateCartList, object: self, userInfo: nil)
        
        print("cartlist remove post")
    }
    
    var datas: [Bool]  = {
        var array: [Bool] = []
        for numbers in 0...1000 {
            array.append(false)
        }
        return array
    }()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let checkOutVC = segue.destination as? CheckOutViewController else {return}
        checkOutVC.cartItems = CartViewController.cartData
    }
    
    @IBAction func checkOutForCart(_ sender: Any) {
        
    }
    
}
