//
//  ShoppingRepository.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/08.
//

protocol ShoppingRepository {
    func searchShoppingList(query: SearchQuery, completion: @escaping (ProductPage) -> Void) 
}
