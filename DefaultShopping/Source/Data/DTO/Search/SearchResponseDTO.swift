//
//  SearchResponseDTO.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/09.
//

import Foundation

struct SearchResponseDTO: Decodable {
    let total: Int
    let start: Int
    let items: [ProductDTO]
    
    func toDomain() -> ProductPage {
        let totalPage = total/Rule.displayCount == 0 ? total/Rule.displayCount : (total/Rule.displayCount)+1
        let currentPage = (start/Rule.displayCount)+1
        return .init(totalPage: totalPage, currentPage: currentPage, productList: items.map{ $0.toDomain() })
    }
}

struct ProductDTO: Decodable {
    let productId: String
    let title: String
    let link: String
    let image: String
    let lprice: String
    let mallName: String
    
    func toDomain() -> Product {
        let id = Int(productId) ?? 0
        let price = Int(lprice) ?? 0
        return .init(id: id, title: title.removeHTMLTag(), imagePath: image, price: price, detailLink: link, mall: mallName, like: false)
    }
}
