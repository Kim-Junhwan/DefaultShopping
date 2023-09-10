//
//  DegaultShoppingRepository.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/09.
//

import Foundation

final class DefaultShoppingRepository {
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultShoppingRepository: ShoppingRepository {
    
    func searchShoppingList(query: SearchQuery, completion: @escaping (Result<ProductPage, Error>) -> Void) {
        let endpoint = APIEndpoints.searchProduct(requestDTO: .init(page: query.page, query: query.query, sort: query.sort))
        dataTransferService.request(endpoint: endpoint) { result in
            switch result {
            case .success(let success):
                completion(.success(success.toDomain()))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
}
