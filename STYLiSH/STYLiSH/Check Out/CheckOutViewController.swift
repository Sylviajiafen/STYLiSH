import UIKit
import Kingfisher

class CheckOutViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let header = [NSLocalizedString("結帳商品", comment: ""), NSLocalizedString("收件資訊", comment: ""), NSLocalizedString("付款詳情", comment: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.white
        
        // 註冊結帳商品的 cell
        tableView.lk_registerCellWithNib(
            identifier: String(describing: STOrderProductCell.self), bundle: nil)
        
        // 註冊收件資訊的 cell
        tableView.lk_registerCellWithNib(
            identifier: String(describing: STOrderUserInputCell.self), bundle: nil)
        
        // 註冊付款詳情的 cell
        tableView.lk_registerCellWithNib(
            identifier: String(describing: STPaymentInfoTableViewCell.self), bundle: nil)
        
        let headerXib = UINib(nibName: String(describing: STOrderHeaderView.self), bundle: nil)
        
        tableView.register(headerXib, forHeaderFooterViewReuseIdentifier: String(describing: STOrderHeaderView.self))
        
        print("VC====userInput:\(userInputStatus)")
    }
    
    // 傳遞購物車資料
    var cartItems: [Cart] = []
    
    var getRecipient = Recipient(name: "", phone: "", email: "", address: "", time: "")
    var getOrder = Order(shipping: "",
                         payment: "",
                         subtotal: 0,
                         freight: 0,
                         total: 0,
                         recipient: Recipient(name: "", phone: "", email: "", address: "", time: ""),
                         list: [List(id: "", name: "", price: 0, color: Color(name: "", code: ""),
                                     size: "", qtn: 0)])
    var getSum: Int = 0
    var getTotal: Int = 0
    var getColor = Color(name: "", code: "")
    var getListArray: [List] = []
  
    var userInputStatus: Bool = false
    var userCreditPayMent: Bool = false
    
    func showAlert() -> Bool {
        if userInputStatus == false {
            
            let inputAlert = UIAlertController(title: "", message: NSLocalizedString("請輸入完整收件資訊", comment: ""), preferredStyle: .alert)
            let inputAction = UIAlertAction(title: "back", style: .cancel)
            inputAlert.addAction(inputAction)
            present(inputAlert, animated: true, completion: nil)
            
            return true
        }
        return false
    }
    
    func checkoutSave() {
        
        let totalIndex = cartItems.count
        
        for index in 0..<totalIndex {
            let prices = Int(cartItems[index].selectedPrice) * Int(cartItems[index].selectedQuant)
            getSum += prices
            getColor = Color(name: cartItems[index].selectedColorName ?? "unkenown color name",
                                  code: cartItems[index].selectedColor ?? "unKnown color code")
            
            getListArray.append(List(id: cartItems[index].selectedID ?? "unknown ID",
                                          name: cartItems[index].selectedName ?? "unKnown name",
                                          price: Int(cartItems[index].selectedPrice) ,
                                          color: self.getColor,
                                          size: cartItems[index].selectedSize ?? "unknown size",
                                          qtn: Int(cartItems[index].selectedQuant) ))
            
            getTotal = self.getSum + (totalIndex * 60)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func unwindToCheckout(_ unwindSegue: UIStoryboardSegue) {
    }
}
//swiftlint:disable line_length
extension CheckOutViewController: UITableViewDataSource, UITableViewDelegate {
    
    // 設定 header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 67.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: STOrderHeaderView.self)) as? STOrderHeaderView else {
            return nil
        }
        
        headerView.titleLabel.text = header[section]
        headerView.contentView.backgroundColor = UIColor.white
        return headerView
    }
    
    // 隱藏 footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let footerView = view as? UITableViewHeaderFooterView else { return }
        footerView.contentView.backgroundColor = UIColor.hexStringToUIColor(hex: "cccccc")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return header.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return cartItems.count
        }
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Todo
        /*
        所有的 cell 都還沒有餵資料進去，請把購物車的資料，適當的傳遞到 Cell 當中
         */
        var cell: UITableViewCell
        
        // 計算總金額
        let totalIndex = cartItems.count
        var sumOfPrices = 0
        for index in 0..<totalIndex {
            let prices = Int(cartItems[index].selectedPrice) * Int(cartItems[index].selectedQuant)
            
            sumOfPrices += prices
            
//            print("＝＝＝總金額＝＝＝")
//            print(sumOfPrices)
        }
       
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: STOrderProductCell.self), for: indexPath)
                as? STOrderProductCell else {fatalError()}
            let cartImage = URL(string: cartItems[indexPath.row].selectedImage ?? "no images")
            cell.productImageView.kf.setImage(with: cartImage)
            cell.colorView.backgroundColor = UIColor(hexString: cartItems[indexPath.row].selectedColor ?? "no color")
            cell.priceLabel.text = "NT$ \(cartItems[indexPath.row].selectedPrice)"
            cell.orderNumberLabel.text = "x \(cartItems[indexPath.row].selectedQuant)"
            cell.productSizeLabel.text = String(cartItems[indexPath.row].selectedSize ?? "no size")
            cell.productTitleLabel.text = String(cartItems[indexPath.row].selectedName ?? "no name")
            
            return cell
            
        } else if indexPath.section == 1 {
            
             guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: STOrderUserInputCell.self), for: indexPath)
                    as? STOrderUserInputCell else {fatalError()}
            
            //Todo
            /*
                請適當的安排 STOrderUserInputCell，讓 ViewController 可以收到使用者的輸入
             */
            
            cell.delegate = self
            
//            print("====收件欄狀態=====")
//            print(userInputStatus)
            
            return cell
            
        } else {
            
            cell = tableView.dequeueReusableCell(withIdentifier: String(describing: STPaymentInfoTableViewCell.self), for: indexPath)
            
            guard let paymentCell = cell as? STPaymentInfoTableViewCell else {return cell}
                
            paymentCell.delegate = self
            
            paymentCell.layoutCellWith(productPrice: sumOfPrices, shipPrice: cartItems.count * 60, productCount: cartItems.count)
            
//            print("＝＝＝正確總金額＝＝＝")
//            print(sumOfPrices)
            return paymentCell
        }
    }
}
//swiftlint:disable function_parameter_count
extension CheckOutViewController: STOrderUserInputCellDelegate {
    
    // VC 拿到第二個 cell 的 user input 資料, 可以在這裡做任何事情
    func didChangeUserData(_ cell: STOrderUserInputCell,
                           username: String,
                           email: String,
                           phoneNumber: String,
                           address: String,
                           shipTime: String) {
        
        print(username, email, phoneNumber, address, shipTime)
        
        if username != "" && email != "" && phoneNumber != "" && address != "" && shipTime != "" {
            userInputStatus = true
            self.getRecipient = Recipient(name: username,
                                          phone: phoneNumber,
                                          email: email,
                                          address: address,
                                          time: shipTime)
        }
        
        print("====userInput:\(userInputStatus)")
        btnUpdate()
    }
}

extension CheckOutViewController: STPaymentInfoTableViewCellDelegate {
    
    func didChangePaymentMethod(_ cell: STPaymentInfoTableViewCell) {
        tableView.reloadData()
    }
    
    func didChangeUserData(
        _ cell: STPaymentInfoTableViewCell,
        payment: String,
        cardNumber: String,
        dueDate: String,
        verifyCode: String
        ) {
            print(payment, cardNumber, dueDate, verifyCode)
        
            if payment == PaymentMethod.getTitleFor(title: .creditCard) {
            
                userCreditPayMent = true
            
                    checkoutSave()
                    getOrder = Order(shipping: "delivery",
                                     payment: payment,
                                     subtotal: getSum,
                                     freight: cartItems.count,
                                     total: getTotal,
                                     recipient: getRecipient,
                                     list: getListArray)
                
            } else {
                userCreditPayMent = false
            }

            print("=========\(userCreditPayMent)========")
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let tapPayVC = segue.destination as? TapPayViewController else {return}
        print("=== prepare order: \(self.getOrder)")
        tapPayVC.creditOrder = self.getOrder
    }
    
    func setBtn(_ button: UIButton) {
        
        if userInputStatus == true {
//            if userCreditPayMent == false || userCreditPayMent == true {
                button.backgroundColor = UIColor(red: 63/255, green: 63/255, blue: 58/255, alpha: 1.0)
//            }
        } else {
            button.backgroundColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
        }
    }
    
    func btnUpdate() {
        guard let paymentCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2))
            as? STPaymentInfoTableViewCell else {return}
        setBtn(paymentCell.confirmToCheckOutBtn)
    }
    
     //swiftlint:disable opening_brace
    func checkout(_ cell: STPaymentInfoTableViewCell) {
        
        if showAlert() {
            return
        } // 判斷有沒有資訊沒填
        
        if ConfirmLogInViewController().keychain["stylishToken"] == nil { // 判斷使用者登入與否
            performSegue(withIdentifier: "confirmLogIn", sender: self)
            
        } else {
            print("==有token==")
            print(ConfirmLogInViewController().keychain["stylishToken"] ?? "nil")
            print(ConfirmLogInViewController().keychain)
            
            if userInputStatus == true && userCreditPayMent == false { // 貨到付款的情況
                
                if let successController = storyboard?.instantiateViewController(withIdentifier: "checkOutSucceded")
                    { present(successController, animated: true, completion: nil) }
                
            } else if userInputStatus == true && userCreditPayMent == true { // 信用卡付款
                
                performSegue(withIdentifier: "showTapPay", sender: self)
            }
        }
    }
}
