//
//  SearchRequestDTO.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/09.
//

import Foundation

struct SearchRequestDTO: Encodable {
    let query: String
    let sort: String
    let start: Int
    
    init(page: Int, query: String, sort: SearchQuery.Sort) {
        self.query = query
        self.sort = sort.rawValue
        self.start = ((page-1) * Rule.displayCount) + 1
    }
}
