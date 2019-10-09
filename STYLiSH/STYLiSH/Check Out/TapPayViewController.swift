//
//  TabPayViewController.swift
//  STYLiSH
//
//  Created by Sylvia Jia Fen  on 2019/7/30.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class TapPayViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    var creditOrder = Order(shipping: "",
                            payment: "",
                            subtotal: 0,
                            freight: 0,
                            total: 0,
                            recipient: Recipient(name: "",
                                                 phone: "",
                                                 email: "",
                                                 address: "",
                                                 time: ""),
                            list: [])
    
    @IBOutlet weak var tapPayView: UIView!
    @IBOutlet weak var tapPayBtn: UIButton!
    
//    var checkoutData
    
    var tpdCard: TPDCard!
    var tpdForm: TPDForm! // 取得消費者資訊之欄位

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tpdForm = TPDForm.setup(withContainer: tapPayView)
        
        tpdForm.setErrorColor(UIColor.red)
        tpdForm.setOkColor(UIColor.green)
        tpdForm.setNormalColor(UIColor.black)
        tpdForm.setIsUsedCcv(true)
        
        self.tpdForm.onFormUpdated { (status) in
            
            weak var weakSelf = self
            
            weakSelf?.tapPayBtn.isEnabled = status.isCanGetPrime()
            weakSelf?.tapPayBtn.alpha = (status.isCanGetPrime()) ? 1.0 : 0.25
        }
        
        self.tapPayBtn.isEnabled = false
        self.tapPayBtn.alpha = 0.25
    }
    
    var prime: String = ""
    
    @IBAction func tapPayBtnPressed(_ sender: Any) {
        
        tpdCard = TPDCard.setup(self.tpdForm)  // 拿到信用卡卡片資訊
        
        tpdCard.onSuccessCallback { (prime, cardInfo, cardIdentifier) in
            
            guard let tapPrime = prime else {return}
            self.prime = tapPrime
            
            print("======我的prime: \(self.prime)====")
            self.checkOutApi()
            
            }.onFailureCallback { (status, message) in
                
                let result = "status: \(status), message: \(message)"
                print(result)
        }.getPrime()
    
}
    
    func checkOutApi() {
        
        // URL
        let checkoutURL = URL(string: "https://api.appworks-school.tw/api/1.0/order/checkout")
        guard let url = checkoutURL else {return}
        var request = URLRequest(url: url)
        
        // Method
        request.httpMethod = "POST"
        
        // Header
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        
        // Body
        let body = CheckOut(prime: self.prime, order: self.creditOrder)
        
        // 把我們的 body 資訊變成 application/json 的形式
        let bodyData = try? JSONEncoder().encode(body)
        request.httpBody = bodyData
        
        // Send Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
               
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {return}
            let status = httpResponse.statusCode
            
            if status >= 200 && status < 300 {
                
                // request success
                
                guard let data = data else {return}
                
                let checkoutData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                    
                    print(status)
                    print(checkoutData)
               
                    if status == 200 {
                
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "success", sender: self)
                        }
                    }
            
            } else if status >= 400 && status < 500 {
                
                print("client error: \(status)")
                
            } else {
                print("server eror")
            }
            
        }
        task.resume()
        
   }
    
}
