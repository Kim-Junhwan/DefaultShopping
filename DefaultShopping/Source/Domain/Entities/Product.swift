//
//  Product.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/08.
//

struct ProductPage {
    let totalPage: Int
    let currentPage: Int
    let productList: [Product]
}

struct Product {
    let id: Int
    let title: String
    let imagePath: String
    let price: Int
    let detailLink: String
    let mall: String
    let like: Bool
}
