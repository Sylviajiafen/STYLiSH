//
//  HomeDetailViewController.swift
//  STYLiSH
//
//  Created by Sylvia Jia Fen  on 2019/7/19.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController,
UITableViewDelegate, UITableViewDataSource,
UIScrollViewDelegate,
UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var opacityView: UIView!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var detailTopScrollView: UIScrollView!

    let fullScreenSize = UIScreen.main.bounds.size
    var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        opacityView.isHidden = true
        detailTopScrollView.delegate = self
        detailTopScrollView.bounds.size.height = 550
        detailTopScrollView.bounds.size.width = fullScreenSize.width
        detailTopScrollView.contentSize =
            CGSize(width: fullScreenSize.width * CGFloat(product.images.count), height: 550)
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.backgroundColor = UIColor.white

        // scroll view 增加 page control
        detailTopScrollView.isPagingEnabled = true
        pageControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: fullScreenSize.width * 0.85, height: 50))
        pageControl.center = CGPoint(x: 48, y: 520)
        pageControl.numberOfPages = product.images.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor.black

        // 設置上方圖片
        let imagesIndex = product.images.count - 1
        for index in 0...imagesIndex {
            let topImage = UIImageView() 
            topImage.frame = CGRect(x: fullScreenSize.width * CGFloat(index),
                                    y:0, width: fullScreenSize.width, height: 550)
            let imageUrl = URL(string: product.images[index])
            topImage.kf.setImage(with: imageUrl)
            topImage.contentMode = .scaleAspectFill  // 設定照片會依原比例放大
            topImage.clipsToBounds = true  // 設定照片超出頁面範圍時會被切掉

            self.detailTopScrollView.addSubview(topImage)
        }

        detailTableView.addSubview(pageControl)
        detailTableView.bringSubviewToFront(pageControl)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.hidesBackButton = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = true
    }

// 圖片下方的 table view 設定
    var productArray: [Hots] = []
    var product: Product = Product(
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
        images: []
    )

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 85
        } else if indexPath.row == 1 {
            return tableView.estimatedRowHeight
        } else if indexPath.row == 2 {
            return tableView.estimatedRowHeight
        } else {
            return 230
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "product name cell")
                as? ProductNameTableViewCell else {fatalError()}
            cell.nameLabel.text = product.title
            cell.priceLabel.text = "NT$ \(product.price)"
            cell.idLabel.text = "\(product.id)"

            return cell

        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "description cell")
                as? DescriptionTableViewCell  else {fatalError()}

            cell.descriptionLabel.text = product.story

            return cell

        } else if indexPath.row == 2 {
            guard let colorTablecell = tableView.dequeueReusableCell(withIdentifier: "color cell")
                as? ColorTableViewCell else {fatalError()}

            colorTablecell.colorCollectionView.dataSource = self
            colorTablecell.colorCollectionView.delegate = self

            return colorTablecell

        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "detail cell")
                as? DetailTableViewCell else {fatalError()}

            // 尺寸
            for size in product.sizes {
                if product.sizes.count >= 2 {
                    cell.sizeLabel.text = "\(product.sizes[0]) - \(size)"
                } else {
                    cell.sizeLabel.text = "\(size)"
                }
            }

            // 庫存
            var stock = 0
            for variant in product.variants {
                stock += variant.stock
                print(stock)
                cell.stockLabel.text = "\(stock)"
            }

            // 材質
            cell.textureLabel.text = product.texture

            // 洗滌
            cell.laundryLabel.text = product.wash

            // 產地
            cell.originLabel.text = product.place

            // 備註
            cell.remarkLabel.text = product.note

            return cell
        }
    }

    // 設置顏色 collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product.colors.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let collectionCell =
                collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath)

            collectionCell.layer.borderWidth = 0.5
            collectionCell.layer.borderColor = UIColor.darkGray.cgColor
            collectionCell.backgroundColor = UIColor(hexString: product.colors[indexPath.row].code)

        return collectionCell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.size.height
        let width = height
        return CGSize(width: width, height: height)
    }

    // 加入購物車畫面的 exist 點
    @IBAction func unwindTodetail(_ unwindSegue: UIStoryboardSegue) {
        guard unwindSegue.source is AddToCartViewController else { return }
        self.opacityView.isHidden = true
    }

    // 傳值
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let addCartVC = segue.destination as? AddToCartViewController else {return}

        addCartVC.detail = self.product
    }

    @IBAction func addCartBtnPressed(_ sender: Any) {
        self.opacityView.isHidden = false
    }
}


