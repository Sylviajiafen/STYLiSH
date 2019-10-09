//
//  AddToCartViewController.swift
//  STYLiSH
//
//  Created by Sylvia Jia Fen  on 2019/7/23.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit
import CoreData

class AddToCartViewController: UIViewController,
                               UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,
                               UITextFieldDelegate {

    var currentColorIndexPath: IndexPath?
    var currentSizeIndexPath: IndexPath?
    var sizesQuant: Int = 0
    var stock: Int = 0
    var selectedColorString: String = ""
    var selectedSizeString: String = ""
    var selectedColorName: String = ""
    var selectedID: String = ""

    // 品名區塊
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!

    // 顏色區塊
    @IBOutlet weak var colorCollection: UICollectionView!

    // 尺寸區塊
    @IBOutlet weak var sizeCollection: UICollectionView!

    // 數量區塊
    @IBOutlet weak var decreaseQuantityBtn: UIButton!
    @IBOutlet weak var increaseQuantityBtn: UIButton!
    @IBOutlet weak var quantityText: UITextField!
    
    // 加入購物車
    @IBOutlet weak var addToCartBtn: UIButton!
    
    // 傳值用
    var detail: Product = Product(
        id: 0,
        category: "",
        title: "",
        description: "",
        price: 0,
        texture: "",
        wash: "",
        place: "",
        note: "",
        story: "",
        colors: [],
        sizes: [],
        variants: [],
        mainImage: "",
        images: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        colorCollection.dataSource = self
        colorCollection.delegate = self
        sizeCollection.dataSource = self
        sizeCollection.delegate = self
        quantityText.delegate = self

        // 品名區塊設置
        productNameLabel.text = detail.title
        productPriceLabel.text = "NT$ \(detail.price)"

        // 庫存初始設置
        inventoryLabel.text = ""

        // 數量區塊初始設置
        decreaseQuantityBtn.layer.borderWidth = 0.8
        decreaseQuantityBtn.layer.borderColor = UIColor(red: 63/255, green: 63/255, blue: 58/255, alpha: 1).cgColor
        increaseQuantityBtn.layer.borderWidth = 0.8
        increaseQuantityBtn.layer.borderColor = UIColor(red: 63/255, green: 63/255, blue: 58/255, alpha: 1).cgColor
        quantityText.layer.borderWidth = 0.6
        quantityText.layer.borderColor = UIColor(red: 63/255, green: 63/255, blue: 58/255, alpha: 1).cgColor
        quantityText.isEnabled = false
        quantityText.alpha = 0.4
        addToCartBtn.isEnabled = false
        decreaseQuantityBtn.isEnabled = false
        increaseQuantityBtn.isEnabled = false
    }
    
// collection view flow layout

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == colorCollection {
            return detail.colors.count
        } else if collectionView == sizeCollection {
            return detail.sizes.count
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == colorCollection {
            let cell = colorCollection.dequeueReusableCell(withReuseIdentifier: "color", for: indexPath)
            cell.backgroundColor = UIColor(hexString: detail.colors[indexPath.item].code)
            return cell

        } else if collectionView == sizeCollection {
            guard let cell = sizeCollection.dequeueReusableCell(withReuseIdentifier: "size",
                                                                for: indexPath)
                                                                    as? SizeCollectionViewCell else {fatalError()}
            cell.sizeLabel.text = "\(detail.sizes[indexPath.row])"
            cell.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 0.4)
            return cell

        } else {
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.size.height
        let width = height
        return CGSize(width: width, height: height)
    }

// 選擇顏色及尺寸時顯示邊框，並設定只有顏色有被選取的時候，才能選擇尺寸

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
            
        case colorCollection:
            currentColorIndexPath = indexPath
            
            guard let cell = colorCollection.cellForItem(at: indexPath) else {return}
            cell.layer.borderWidth = 0.8
            cell.layer.borderColor = UIColor.darkGray.cgColor
            
            // 讓 size 欄位的字亮起來(變黑色)
            sizeCollection.alpha = 1
            
        case sizeCollection:
            
            // 確認使用者有點選顏色的情況下，尺寸被點選時才會出現 border
            if currentColorIndexPath != nil {
                
                currentSizeIndexPath = indexPath  // 設定 currentSizeIndexPath 是有點選顏色情況下的 尺寸的 indexPath
                
                guard let sizeCell = sizeCollection.cellForItem(at: indexPath) as? SizeCollectionViewCell else {return}
                sizeCell.layer.borderWidth = 0.8
                sizeCell.layer.borderColor = UIColor.darkGray.cgColor
                print("有選擇顏色情況下的 選尺寸/換尺寸")
                
                // 設定 textField, addToCartBtn 初始
                quantityText.isEnabled = true
                quantityText.alpha = 1
                addToCartBtn.alpha = 1
                addToCartBtn.isEnabled = true
                increaseQuantityBtn.isEnabled = true
                // 有選擇顏色的情況下，每次換尺寸或選尺寸時，textField 的值為 1
                textString = 1
                quantityText.text = "\(textString)"
                decreaseQuantityBtn.alpha = 0.4
                decreaseQuantityBtn.isEnabled = false
                print("初始化 text")
                print(textString)
                
            } else { // size 被點選，但 color 未被選
                guard let sizeCell = sizeCollection.cellForItem(at: indexPath) as? SizeCollectionViewCell else {return}
                sizeCell.layer.borderColor = UIColor.clear.cgColor
                print("cannot be touched")
            }
        default: break
        }
        
        // 設定顯示庫存
        // 1. 拿庫存
        sizesQuant = detail.sizes.count
        guard let currentColorIndexPath = currentColorIndexPath,
            let currentSizeIndexPath = currentSizeIndexPath else {return}
        let colorChoosed = currentColorIndexPath.item
        let sizeChoosed = currentSizeIndexPath.item
        let variantStockIndex = colorChoosed * sizesQuant + sizeChoosed
        stock = detail.variants[variantStockIndex].stock
        
        selectedColorString = detail.colors[colorChoosed].code  // 拿使用者選擇的顏色
        selectedSizeString = detail.sizes[sizeChoosed] // 拿使用者選擇的尺寸
        selectedColorName = detail.colors[colorChoosed].name
        selectedID = String(detail.id)
        
        // 2. 顯示庫存
        inventoryLabel.text = NSLocalizedString("stock: ", comment: "") + "\(stock)"
        
        if stock > 1 {
            increaseQuantityBtn.alpha = 1
            increaseQuantityBtn.isEnabled = true
        } else if stock <= 1 {
            increaseQuantityBtn.alpha = 0.4
            increaseQuantityBtn.isEnabled = false
        }
        if stock == 0 {
            quantityText.text = "0"
            quantityText.isEnabled = false
            quantityText.alpha = 0.4
            addToCartBtn.alpha = 0.4
            addToCartBtn.isEnabled = false
        }
        
        print("判斷 stock")
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch collectionView {

        case colorCollection:
            let cell = colorCollection.cellForItem(at: indexPath)
            cell?.layer.borderWidth = 0
            cell?.layer.borderColor = UIColor.clear.cgColor
            print("換顏色")
            
            // 當有選擇尺寸、換顏色的時候，textField 值為 1，顯示 textField 和 addToCartBtn
            if currentSizeIndexPath != nil {
                textString = 1
                quantityText.text = "\(textString)"
                decreaseQuantityBtn.isEnabled = false
                decreaseQuantityBtn.alpha = 0.4
                quantityText.isEnabled = true
                quantityText.alpha = 1
                addToCartBtn.alpha = 1
                addToCartBtn.isEnabled = true
            }

        case sizeCollection:
            let cell  = sizeCollection.cellForItem(at: indexPath)
            cell?.layer.borderWidth = 0
            cell?.layer.borderColor = UIColor.clear.cgColor
            print("不知顏色有沒有選到 選尺寸/換尺寸")

        default: break
        }
    }

// 設置庫存
    @IBOutlet weak var inventoryLabel: UILabel!

// 設置按加減按鈕
    var textString: Int = 0
  
    @IBAction func decreasedPressed(_ sender: Any) {
        increaseQuantityBtn.isEnabled = true
        increaseQuantityBtn.alpha = 1
        
        textString -= 1
        quantityText.text = "\(textString)"
        
        if textString == 1 {
            decreaseQuantityBtn.isEnabled = false
            decreaseQuantityBtn.alpha = 0.4
            print("不能按減")
        }
        print(textString)
    }
    
    @IBAction func increasePressed(_ sender: Any) {
        decreaseQuantityBtn.isEnabled = true
        decreaseQuantityBtn.alpha = 1
        
        textString += 1
        quantityText.text = "\(textString)"
        
        if textString == stock {
            increaseQuantityBtn.isEnabled = false
            increaseQuantityBtn.alpha = 0.4
            print("不能按加")
        }
        print(textString)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let customTextValue = Int(quantityText.text ?? "0") ?? 1
        if customTextValue <= stock {
            textString = customTextValue
        } else {
            textString = stock
        }
        quantityText.text = "\(textString)"
        print(textString)
    }
    
    
    // (成功加入 alert 完成後進入的 func)
    func addToCartComplete() {
    }
    
    @IBAction func addToCartPressed(_ sender: Any) {
        
        // 秀出加入購物車成功
        let alert = UIAlertController(title: "", message: "Added to cart！", preferredStyle: .alert)
        let action = UIAlertAction(title: "back", style: .default) { (UIAlertAction) in
            self.addToCartComplete()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        print("有成功")
        
        // 存進 Core Data 中
        func saveToCoreData() {
            let cart = Cart(context: StorageManager.shared.persistentContainer.viewContext)
            
            cart.selectedName = detail.title
            cart.selectedPrice = Int16(detail.price)
            cart.selectedImage = detail.mainImage
            cart.selectedQuant = Int16(self.textString)
            cart.selectedColor = self.selectedColorString
            cart.selectedSize = self.selectedSizeString
            cart.selectedStock = Int16(self.stock)
            cart.selectedColorName = self.selectedColorName
            cart.selectedID = String(detail.id)
            
            print(cart)
            
            do {
                try StorageManager.shared.persistentContainer.viewContext.save() // 儲存進 SQLite
            } catch {
                fatalError()
            }
        }
        saveToCoreData()
         // Notice
        fetchFromCoreData()
        NotificationCenter.default.post(name: .didCreateCartList, object: self, userInfo: nil)
        print("add to cart post")
        
    }
    
    // 秀出加入購物車成功II
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}

