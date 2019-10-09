//
//  ViewController.swift
//  STYLiSH
//
//  Created by Sylvia Jia Fen  on 2019/7/10.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit
import Kingfisher
import CRRefresh

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MarketManagerDelegate {

    @IBOutlet weak var homeTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.backgroundColor = UIColor.white
        marketManager.delegate = self      //-> 讓 class MarketManager 能夠找到 HomeVC
        marketManager.getMarketingHots()

        // 新增 Pull to Refresh
        homeTableView.cr.addHeadRefresh {
            self.marketManager.getMarketingHots()
        }
        print("有pulltorefresh")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return hotsArray.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotsArray[section].products.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row % 2 == 0 { //<- 因為 idex 是從 0 開始，這時候 indexPath.row 為奇數(第奇數個cell)

            let imageUrl = URL(string: hotsArray[indexPath.section].products[indexPath.row].mainImage)

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
                as? FirstTableViewCell else { fatalError() }

            cell.firstCellLabelTitle.text = hotsArray[indexPath.section].products[indexPath.row].title
            cell.firstCellLabelContent.text = hotsArray[indexPath.section].products[indexPath.row].description
            cell.firstCellImage.kf.setImage(with: imageUrl)

            return cell

        } else {

            let imageLeft = URL(string: hotsArray[indexPath.section].products[indexPath.row].images[0])
            let imageMidUp = URL(string: hotsArray[indexPath.section].products[indexPath.row].images[1])
            let imageMidDown = URL(string: hotsArray[indexPath.section].products[indexPath.row].images[2])
            let imageRight = URL(string: hotsArray[indexPath.section].products[indexPath.row].images[3])

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
                as? SecondTableViewCell else { fatalError() }

            cell.secondCellLabelTitle.text = hotsArray[indexPath.section].products[indexPath.row].title
            cell.secondCellLabelContent.text = hotsArray[indexPath.section].products[indexPath.row].description
            cell.secondCellImageLeft.kf.setImage(with: imageLeft)
            cell.secondCellImageMidUp.kf.setImage(with: imageMidUp)
            cell.seconCellImageMidDown.kf.setImage(with: imageMidDown)
            cell.secondCellImageRight.kf.setImage(with: imageRight)

            return cell
        }
     }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

            let headerView = UIView()
            headerView.frame = CGRect(x: 0, y: 0, width: homeTableView.frame.width, height: 40)
            headerView.backgroundColor = UIColor.white

            let headerLabel = UILabel()
            headerLabel.text = hotsArray[section].title
            headerLabel.textColor = UIColor(red: 63.0/255.0, green: 58.0/255.0, blue: 58.0/255.0, alpha: 1.0)
            headerLabel.font = UIFont(name: "NotoSansCJKtc-Medium", size: 18.0)
            headerLabel.frame = CGRect(x: 16, y: 24, width: 145, height: 27)

            headerView.addSubview(headerLabel)

            return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    // API things

    // 創造一個叫做 "marketManager" 的東西，其為 class type "MarketManager" 的 instance
    let marketManager: MarketManager = MarketManager()
    // 到 view didload 把這位 "marketManager" 的 delegate 設為 VC (self)

    // 創造一個 array， 其為 struct type 的 instance
    var hotsArray: [Hots] = []

    func manager(_ manager: MarketManager, didGet marketingHots: [Hots]) {
        hotsArray = marketingHots
//        print(hotsArray)

        DispatchQueue.main.async {
            self.homeTableView.reloadData()
            self.homeTableView.cr.endHeaderRefresh()
        }
    }

    func manager(_ manager: MarketManager, didFailWith error: Error) {
        print(error)
    }

// 傳 data 給 detail view

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "homeDetail", sender: UITableViewCell.self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? DetailViewController else { return }

        if let homeSection = homeTableView.indexPathForSelectedRow?.section {
            if let homeRow = homeTableView.indexPathForSelectedRow?.row {
                detailVC.product = self.hotsArray[homeSection].products[homeRow]
            }
        }
    }

// 設置 back button 的 exist 點
    @IBAction func unwindToname(_ unwindSegue: UIStoryboardSegue) {
        guard unwindSegue.source is DetailViewController else { return }
    }

}
