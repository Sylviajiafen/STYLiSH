//
//  ViewController.swift
//  Week_2_part_1
//
//  Created by Sylvia Jia Fen  on 2019/7/14.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,
                             UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var myCollectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var titleView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        titleView.backgroundColor = UIColor(red: 63.0/255.0, green: 58.0/255.0, blue: 58.0/255.0, alpha: 1.0)

        // 設置上下左右之間距
        myCollectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 30, left: 16, bottom: 20, right: 16)
        // 設置 cell 的 size
//        myCollectionViewFlowLayout.itemSize = CGSize(width: fullScreenSize.width/4-24, height: 51)
        // 設置 cell 與 cell 間的間距(直向)～ 若 direction 為 .horizontal 此 func 變為橫向間距
        myCollectionViewFlowLayout.minimumLineSpacing = 30
        // 設定滾動方向為上下
        myCollectionViewFlowLayout.scrollDirection = .vertical
        // 設置 header 尺寸
        myCollectionViewFlowLayout.headerReferenceSize = CGSize(width: fullScreenSize.width, height: 40)
        myCollectionViewFlowLayout.footerReferenceSize = CGSize(width: fullScreenSize.width, height: 0)
    }

    // 取得手機螢幕大小
    let fullScreenSize = UIScreen.main.bounds.size

    // 設定 section 數
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    // 定義 item(cell) 中的東東
    struct SectionsInfo {
        var title: String
        var items: [ItemsInfo]
    }

    struct ItemsInfo {
        var label: String
        var icons: String
    }

    let myOrderItemsInfo = [
        ItemsInfo(label: NSLocalizedString("waitToPay", comment: ""), icons: "AwaitingPayment"),
        ItemsInfo(label: NSLocalizedString("waitToShip", comment: ""), icons: "AwaitingShipment"),
        ItemsInfo(label: NSLocalizedString("waitToSign", comment: ""), icons: "Shipped"),
        ItemsInfo(label: NSLocalizedString("waitToEvaluate", comment: ""), icons: "AwaitingReview"),
        ItemsInfo(label: NSLocalizedString("return", comment: ""), icons: "Exchange")]

    let serviceItemsInfo = [
        ItemsInfo(label: NSLocalizedString("collection", comment: ""), icons: "Starred"),
        ItemsInfo(label: NSLocalizedString("notice", comment: ""), icons: "Notification"),
        ItemsInfo(label: NSLocalizedString("refund", comment: ""), icons: "Refunded"),
        ItemsInfo(label: NSLocalizedString("address", comment: ""), icons: "Address"),
        ItemsInfo(label: NSLocalizedString("message", comment: ""), icons: "CustomerService"),
        ItemsInfo(label: NSLocalizedString("feedBack", comment: ""), icons: "SystemFeedback"),
        ItemsInfo(label: NSLocalizedString("phoneBind", comment: ""), icons: "RegisterCellphone"),
        ItemsInfo(label: NSLocalizedString("setting", comment: ""), icons: "Settings")]

    // 設定不同 section 中的 item(cell) 數
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        let sections = [
         SectionsInfo(title: "我的訂單", items: myOrderItemsInfo),
         SectionsInfo(title: "更多服務", items: serviceItemsInfo)]

        if section == 0 {
            return sections[section].items.count
        } else {
            return sections[section].items.count
        }
    }

    // 設置 cell 的 size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        if indexPath.section == 0 {
            return CGSize(width: fullScreenSize.width/4-32, height: 51)
        } else {
            return CGSize(width: fullScreenSize.width/4-24, height: 51)
        }
    }

    // 不同 section 中的 cell 間距(橫向)～ 若 direction 為 .horizontal 此 func 變為直向間距
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        if section == 0 {
            return 5
        } else {
            return 11
        }
    }

    // 設置 cell
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        guard let profileCell = cell as? MyCollectionViewCell else {return cell}

        let sections = [
            SectionsInfo(title: "我的訂單", items: myOrderItemsInfo),
            SectionsInfo(title: "更多服務", items: serviceItemsInfo)]

        profileCell.cellLabel.text = sections[indexPath.section].items[indexPath.row].label
        profileCell.image.image = UIImage(named: "\(sections[indexPath.section].items[indexPath.row].icons)")

        return cell
    }

    // 設置 header
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        var reusableView = UICollectionReusableView()

        let headerLabel = UILabel(frame: CGRect(x: 16, y: 16, width: 150, height: 24))
        headerLabel.textAlignment = .left
        headerLabel.numberOfLines = 0

        let headerTitle = [NSLocalizedString("myOrder", comment: ""), NSLocalizedString("moreService", comment: "")]

        if kind == UICollectionView.elementKindSectionHeader {
            reusableView =
                collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                withReuseIdentifier: "HeaderView",
                                                                for: indexPath)

            guard let header = reusableView as? HeaderCollectionReusableView else {return reusableView}

            headerLabel.text = headerTitle[indexPath.section]
            header.addSubview(headerLabel)

            if indexPath.section == 1 {
                header.checkAllButton.isHidden = true
            }
        }
        return reusableView
    }

}
