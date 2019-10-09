//
//  FemaleProducts.swift
//  STYLiSH
//
//  Created by Sylvia Jia Fen  on 2019/7/16.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import Foundation
import Alamofire

let femaleProductsUrl = "https://api.appworks-school.tw/api/1.0/products/women"

struct PageData: Codable {
    var paging: Int?
    var data: [Product]
}

class ProductsManager {

    weak var delegate: CatalogDelegate?

    func getProducts(endPoint: String, page: Int) {
//        print("我有認真getFemaleProducts喔～")

        let head = "https://api.appworks-school.tw/api/1.0"
        let query = "?paging=\(page)"

        AF.request(head+endPoint+query).responseJSON { response in

            guard let data = response.data else {return}

            do { let pageData = try JSONDecoder().decode(PageData.self, from: data)

                self.delegate?.manager(self, didGet: pageData)

            } catch {
                print(error)
            }
        }
    }
}

protocol CatalogDelegate: AnyObject {
    func manager(_ manager: ProductsManager, didGet products: PageData)
    func manager(_ manager: ProductsManager, didFailWith error: Error)
}
