//
//  CatalogViewController.swift
//  STYLiSH
//
//  Created by Sylvia Jia Fen  on 2019/7/15.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import ESPullToRefresh

class CatalogViewController: UIViewController,
                             UITableViewDataSource, UITableViewDelegate,
                             CatalogDelegate,
                             UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var slideView: UIView!
    @IBOutlet weak var girlButton: UIButton!
    @IBOutlet weak var boyButton: UIButton!
    @IBOutlet weak var accessoriesButton: UIButton!
    @IBOutlet weak var catalogTableView: UITableView!
    @IBOutlet weak var catalogCollectionView: UICollectionView!
    @IBOutlet weak var catalogCollectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var switchDataViewButton: UIBarButtonItem!

    let fullScreenSize = UIScreen.main.bounds.size

    var paging: Int = 0
    var endPoint: EndPoints = .female

    var nextPage: Int? = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        catalogTableView.dataSource = self
        catalogTableView.delegate = self
        catalogTableView.backgroundColor = UIColor.white
        catalogCollectionView.dataSource = self
        catalogCollectionView.delegate = self

        // 隱藏 under line of navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

        // 取消 slideView 的 AutoLayout
        slideView.translatesAutoresizingMaskIntoConstraints = false

        // 設置 collection view 的 layout
        catalogCollectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 24, left: 16, bottom: 0, right: 16)
        catalogCollectionViewFlowLayout.itemSize = CGSize(width: fullScreenSize.width/2-24, height: 320)
        catalogCollectionViewFlowLayout.scrollDirection = .vertical
        catalogCollectionViewFlowLayout.minimumLineSpacing = 0
        catalogCollectionViewFlowLayout.minimumInteritemSpacing = 12

        // 設定初始畫面是 girlbutton 為點擊狀態
        girlButton.isSelected = true

        // 拿網路資料
        manager.delegate = self
        manager.getProducts(endPoint: self.endPoint.rawValue, page: self.paging)    // 初始畫面為 women products

        // 設置 table view 的下拉更新
        catalogTableView.es.addPullToRefresh {
            self.productsArray = []    // 先清空原本畫面上的檔案
            self.paging = 0

            self.manager.getProducts(endPoint: self.endPoint.rawValue, page: self.paging)

        }
        // 設置 collection view 的下拉更新
        catalogCollectionView.es.addPullToRefresh {
            self.productsArray = []    // 先清空原本畫面上的檔案
            self.paging = 0

            self.manager.getProducts(endPoint: self.endPoint.rawValue, page: self.paging)
        }

        // table view 上載更多

        self.catalogTableView.es.addInfiniteScrolling {
            if self.nextPage != nil {
                self.paging += 1
                self.manager.getProducts(endPoint: self.endPoint.rawValue, page: self.paging)
            }
        }

        // collection view 上載更多
        self.catalogCollectionView.es.addInfiniteScrolling {
            if self.nextPage != nil {
                self.paging += 1
                self.manager.getProducts(endPoint: self.endPoint.rawValue, page: self.paging)
            }
        }
    }

// 設置上方分類按鈕點擊事件
    @IBAction func buttomPressed(_ sender: UIButton) {

        let yPosition = slideView.frame.origin.y
        let width = slideView.frame.width
        let height = slideView.frame.height

        switch sender {

        case boyButton:
            slideView.frame = CGRect(x: fullScreenSize.width/3, y: yPosition, width: width, height: height)
            boyButton.isSelected = true
            girlButton.isSelected = false
            accessoriesButton.isSelected = false

            // 畫面資料
            self.endPoint = .male
            self.productsArray = []    // 先清空原本畫面上的檔案
            self.paging = 0
            manager.getProducts(endPoint: self.endPoint.rawValue, page: self.paging)

        case accessoriesButton:
            slideView.frame = CGRect(x: fullScreenSize.width/3*2, y: yPosition, width: width, height: height)
            accessoriesButton.isSelected = true
            girlButton.isSelected = false
            boyButton.isSelected = false

            // 畫面資料
            self.endPoint = .acc
            self.productsArray = []    // 先清空原本畫面上的檔案
            self.paging = 0
            manager.getProducts(endPoint: self.endPoint.rawValue, page: self.paging)

        case girlButton:
            slideView.frame =
                CGRect(x: fullScreenSize.width/3-fullScreenSize.width/3, y: yPosition, width: width, height: height)
            girlButton.isSelected = true
            boyButton.isSelected = false
            accessoriesButton.isSelected = false

            // 畫面資料
            self.endPoint = .female
            self.productsArray = []    // 先清空原本畫面上的檔案
            self.paging = 0
            manager.getProducts(endPoint: self.endPoint.rawValue, page: self.paging)

        default:
            break
        }
    }

// API things

    let manager: ProductsManager = ProductsManager()

    var productsArray: [Product] = []

    func manager(_ manager: ProductsManager, didGet products: PageData) {

        DispatchQueue.main.async {

            // 把抓到的資料放進 productsArray = [] (空的) 裡面裡面； append(contents of:) 是把 array 中的資料夾到另一個 array 中
            self.productsArray.append(contentsOf: products.data)
            //====================================
            print(self.productsArray.count)
            //====================================

            self.catalogTableView.reloadData()
            self.catalogTableView.es.stopPullToRefresh()

            self.catalogCollectionView.reloadData()
            self.catalogCollectionView.es.stopPullToRefresh()

            self.nextPage = products.paging

            if self.nextPage == nil {
                    self.catalogTableView.es.noticeNoMoreData()
                    self.catalogTableView.footer?.alpha = CGFloat(1)
                print("table沒有更多資料")
                    self.catalogCollectionView.es.noticeNoMoreData()
                    self.catalogCollectionView.footer?.alpha = CGFloat(1)
                print("collection沒有更多資料")
            }
        }
    }

    func manager(_ manager: ProductsManager, didFailWith error: Error) {
        print(error)
    }

// 頁面一：tableView settings

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell =
            catalogTableView.dequeueReusableCell(withIdentifier: "catalogCell", for: indexPath)
                as? CatalogTableViewCell else { fatalError() }

        cell.priceLabel.text = "NT$ \(productsArray[indexPath.row].price)"
        cell.productNameLabel.text = productsArray[indexPath.row].title

        let imageURL = URL(string: productsArray[indexPath.row].mainImage)
        cell.catalogImage.kf.setImage(with: imageURL)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

// 頁面二：collectionView settings

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {

        let cell =
            catalogCollectionView.dequeueReusableCell(withReuseIdentifier: "CatalogCollectionCell", for: indexPath)
        guard let collectionCell = cell as? CatlogCollectionViewCell else {return cell}

        collectionCell.catalogCellLabel.text = productsArray[indexPath.item].title
        collectionCell.catalogCellPrice.text = "NT$ \(productsArray[indexPath.item].price)"
        let imageURL = URL(string: productsArray[indexPath.item].mainImage)
        collectionCell.catalogCellImage.kf.setImage(with: imageURL)

        return cell
    }

// 設置切換 data view 按鈕的點擊事件

    @IBAction func switchDataViewButtonPressed(_ sender: UIBarButtonItem) {

        if self.catalogCollectionView.alpha == CGFloat(0) {
            self.catalogTableView.alpha = 0
            self.catalogCollectionView.alpha = 1
            self.switchDataViewButton.image = UIImage(named: "Icons_24px_ListView")
        } else if catalogCollectionView.alpha == CGFloat(1) {
            self.catalogTableView.alpha = 1
            self.catalogCollectionView.alpha = 0
            self.switchDataViewButton.image = UIImage(named: "Icons_24px_CollectionView")
        } else {
            print("view switching error!")
        }
    }

/*__________________________________________________________________________
 流程：
     使用者點選了某個 indexPath 的 cell，來到 func ... ..... didSelectItem/RowAt
     這時候會叫到 performSegue，
     performSegue 被叫到後會到 override func prepare...，
     拿到資料後，再傳到 destanation 的 VC
 ----------------------------------------------------------------------------
 */

// 設置跳轉至 detail view 的 segue
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "catalogToDetail", sender: indexPath)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "catalogToDetail", sender: indexPath)
    }

// 傳值

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? DetailViewController else { return }

        guard let indexPath = sender as? IndexPath else {
            fatalError()
        }
        detailVC.product = self.productsArray[indexPath.row]
    }

// 設置 back button 的 exist 點
    @IBAction func unwindToname(_ unwindSegue: UIStoryboardSegue) {
        guard unwindSegue.source is DetailViewController else { return }
    }

    
    
}
