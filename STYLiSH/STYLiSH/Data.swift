//
//  Products.swift
//  STYLiSH
//
//  Created by Sylvia Jia Fen  on 2019/7/11.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import Foundation

class APIs {
    enum Endpoint: String {
        case hots = "https://api.appworks-school.tw/api/1.0/marketing/hots"

        var url: URL {
            return URL(string: self.rawValue)!
        }
    }
}

enum EndPoints: String {
    case hot = "/marketing/hots"
    case female = "/products/women"
    case male = "/products/men"
    case acc = "/products/accessories"
}

struct Data: Codable {
    let data: [Hots]
}

//struct ProuductData: Codable {
//    let title: String
//    let products: [Product]
//}

struct Hots: Codable {
    let title: String
    let products: [Product]
}

struct Product: Codable {
    var id: Int
    var category: String
    var title: String
    var description: String
    var price: Int
    var texture: String
    var wash: String
    var place: String
    var note: String
    var story: String
    var colors: [Color]
    var sizes: [String]
    var variants: [Variant]
    var mainImage: String
    var images: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case category
        case title
        case description
        case price
        case texture
        case wash
        case place
        case note
        case story
        case colors
        case sizes
        case variants
        case mainImage = "main_image"
        case images
    }
}

struct Color: Codable {
    var name: String
    var code: String
}

struct Variant: Codable {
    var colorCode: String
    var size: String
    var stock: Int

    enum CodingKeys: String, CodingKey {
        case colorCode = "color_code"
        case size
        case stock
    }
}

struct Campaign: Codable {
    var productId: Double
    var picture: String
    var story: String

    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case picture
        case story
    }
}

struct User: Codable {
    let id: Double
    let provider: String
    let name: String
    let email: String
    let picture: String
}

struct FBData: Codable {
    var data: UserData
}

struct UserData: Codable {
        var accessToken: String
        var accessExpired: Int
        var user: User
    
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case accessExpired = "access_expired"
            case user
        }
}

struct List: Codable {
    var id: String
    var name: String
    var price: Int
    var color: Color
    var size: String
    var qtn: Int
}

struct Recipient: Codable {
    var name: String
    var phone: String
    var email: String
    var address: String
    var time: String
}

struct Order: Codable {
    var shipping: String
    var payment: String
    var subtotal: Int
    var freight: Int
    var total: Int
    var recipient: Recipient
    var list: [List]
}

struct CheckOut: Codable {
    var prime: String
    var order: Order
}

// GET data from API and decode JSON
protocol MarketManagerDelegate: AnyObject {
    func manager(_ manager: MarketManager, didGet marketingHots: [Hots])
    func manager(_ manager: MarketManager, didFailWith error: Error)
}

class MarketManager {

    // 宣告一個可以存在也可以不存在(optional)的代理人叫做 delegate，他會做 protocol MarketManagerDelegate 裡面的事
    weak var delegate: MarketManagerDelegate?

    func getMarketingHots() {
        // 解碼JSON
        let marketingHotEndpoint = APIs.Endpoint.hots.url
        let task = URLSession.shared.dataTask(with: marketingHotEndpoint) { (data, _, error) in

            if error != nil {
                print(error!.localizedDescription)
                self.delegate?.manager(self, didFailWith: error!)
                
                return // 使用 if 檢查 error 一定要記得 return 
            }

            guard let data = data else {return}

            let decoder = JSONDecoder()

            do { let productData = try decoder.decode(Data.self, from: data)
//                print(productData)
//                print(productData.data[0])
                let hotProducts = productData.data
                self.delegate?.manager(self, didGet: hotProducts)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}


// Check Out Api

//protocol CheckOutDelege: AnyObject {
//    func getPrime(_ manager: CheckOutManager, didGet primes: CheckOut)
//}
//
//class CheckOutManager {
//
//    weak var checkoutDelegate: CheckOutDelege?
//}
