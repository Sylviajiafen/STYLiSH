//
//  ConfirmLogInViewController.swift
//  STYLiSH
//
//  Created by Sylvia Jia Fen  on 2019/7/29.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookCore
import FacebookLogin
import KeychainAccess

class ConfirmLogInViewController: UIViewController {
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var logInAlertTitle: UILabel!
    @IBOutlet weak var logInDescript: UILabel!
    @IBOutlet weak var facebookLogInBtn: UIButton!
    
    let keychain = Keychain()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUpView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        logInAlertTitle.font = UIFont(name: "NotoSansCJKtc-Medium", size: 20.0)
//        logInDescript.font = UIFont(name: "NotoSansCJKtc-Medium", size: 18.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func loginFailedAlert() {
        let alert = UIAlertController(title: "", message: NSLocalizedString("登入失敗", comment: ""), preferredStyle: .alert)
        let action = UIAlertAction(title: "back", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func loginSuccessAlert() {
        let alert = UIAlertController(title: "", message: NSLocalizedString("登入成功", comment: ""), preferredStyle: .alert)
        let action = UIAlertAction(title: "back", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //swiftlint:disable function_body_length
    @IBAction func fbBtnPressed(_ sender: Any) {
        
        let loginManager = LoginManager()
        
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: self) { loginResult in
            
            switch loginResult {
            case .failed(let error):
                print(error)
                self.loginFailedAlert()
            
            case .cancelled:
                print("the user cancels login")
                self.loginFailedAlert()
           
            case .success(_, _, let accessToken):
                print("user log in")
                self.title = "FBLogin"
                
                let token = accessToken.tokenString
                print(token)
                
                //URL
                let schoolURL = URL(string: "https://api.appworks-school.tw/api/1.0/user/signin")
                guard let url = schoolURL else {return}
                var request = URLRequest(url: url)

                //Method
                request.httpMethod = "POST"

                //Header
                request.allHTTPHeaderFields = ["Content-Type": "application/json"]

                //Body

                let body = [
                    "provider": "facebook",
                    "access_token": token
                ]
                
                // 把我們的資訊變成 application/json 的形式
                do { let data = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                    
                        request.httpBody = data
                    
                    } catch {
                        print(error)
                    }

                // Send Request
                let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, _, error) in

                    if error != nil {
                        print(error!.localizedDescription)
                        
                        return
                    }
                    guard let data = data else {return}
                    
                    let decoder = JSONDecoder()
                    
                    do { let fbData = try decoder.decode(FBData.self, from: data)
                        
                        let fbUserData = fbData.data
                        print(fbData)
                        print(fbUserData.user.name)
                        print(fbUserData.user.email)
                        print(fbUserData.user.id)
                        print(fbUserData.user.picture)
                        
                        self.keychain["stylishToken"] = fbData.data.accessToken
                        
                        print("========解包=======")
                        print(self.keychain["stylishToken"])
                        
                        self.loginSuccessAlert()
                        self.dismiss(animated: true, completion: nil)
                        
                    } catch {
                        print(error)
                    }
                })
                    task.resume()
            }
        }
    }
}
