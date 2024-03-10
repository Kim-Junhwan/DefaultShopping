//
//  SearchQuery.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/08.
//

enum Sort: String, CaseIterable {
    case sim
    case date
    case dsc
    case asc
    
    var title: String {
        switch self {
        case .sim:
            return "정확도"
        case .date:
            return "날짜순"
        case .asc:
            return "가격낮은순"
        case .dsc:
            return "가격높은순"
        }
    }
}

struct SearchQuery {
    let query: String
    let page: Int
    let sort: Sort
}
