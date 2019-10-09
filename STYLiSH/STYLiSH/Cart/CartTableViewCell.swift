//
//  CartTableViewCell.swift
//  STYLiSH
//
//  Created by Sylvia Jia Fen  on 2019/7/25.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit
import CoreData

class CartTableViewCell: UITableViewCell {
    
    weak var cartViewController: CartViewController?
    
    @IBOutlet weak var cartImage: UIImageView!
    @IBOutlet weak var cartProductName: UILabel!
    @IBOutlet weak var cartProductPrice: UILabel!
    @IBOutlet weak var cartProductColor: UIView!
    @IBOutlet weak var cartProductSize: UILabel!
    @IBOutlet weak var cartQuantText: UITextField!
    @IBOutlet weak var cartIncreaseBtn: UIButton!
    @IBOutlet weak var cartDecreaseBtn: UIButton!
    @IBOutlet weak var removeBtn: UIButton!
    
    var quantity: Int = 1
    var currentIndex: IndexPath?
    
    // Button actions
    @IBAction func cartIncreasePressed(_ sender: Any) {
        
        cartDecreaseBtn.alpha = 1
        cartDecreaseBtn.isEnabled = true

        quantity += 1
        cartQuantText.text = "\(quantity)"
        
//        if let currentIndex = currentIndex {
//            cartViewController?.cartData[currentIndex.row].selectedQuant = Int16(quantity)
//        }
        
        cartViewController?.userDidHitQuanBtn(self)
    }
    
    @IBAction func cartDecreasePressed(_ sender: Any) {
        
        cartIncreaseBtn.alpha = 1
        cartIncreaseBtn.isEnabled = true
        
        quantity -= 1
        cartQuantText.text = "\(quantity)"
        
//        if let currentIndex = currentIndex {
//            cartViewController?.cartData[currentIndex.row].selectedQuant = Int16(quantity)
//        } // 把減去後的數量丟回去 table View 的資料 array 中的 selectedQuant
        
        cartViewController?.userDidHitQuanBtn(self)
    }
    
    @IBAction func cartRemovePressed(_ sender: Any) {
        cartViewController?.userDidRemoveSth(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
