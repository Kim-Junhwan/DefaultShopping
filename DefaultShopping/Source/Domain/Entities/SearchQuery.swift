//
//  SearchQuery.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/08.
//

struct SearchQuery {
    
    enum Sort: String {
        case sim
        case date
        case asc
        case dsc
    }
    
    let query: String
    let page: Int
    let sort: Sort
}
