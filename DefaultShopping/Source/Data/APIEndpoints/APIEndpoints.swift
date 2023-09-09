//
//  APIEndpoints.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/09.
//

import Foundation

struct APIEndpoints {
    static func searchProduct(requestDTO: SearchRequestDTO) -> EndPoint<SearchResponseDTO> {
        return EndPoint(path: "v1/search/shop.json", method: .GET, query: requestDTO)
    }
}
