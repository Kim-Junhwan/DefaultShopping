//
//  SearchProductUseCase.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/08.
//

protocol SearchProductUseCase {
    func search(searchKeyword: String, page: Int, sort: SearchQuery.Sort,completion: @escaping (Result<ProductPage, Error>) -> Void )
}

final class DefaultSearchProductUseCase: SearchProductUseCase {
    
    private let shoppingRepository: ShoppingRepository
    private let bookmarkRepository: BookmarkRepository
    
    init(shoppingRepository: ShoppingRepository, bookmarkRepository: BookmarkRepository) {
        self.shoppingRepository = shoppingRepository
        self.bookmarkRepository = bookmarkRepository
    }
    
    func search(searchKeyword: String, page: Int, sort: SearchQuery.Sort = .sim ,completion: @escaping (Result<ProductPage, Error>) -> Void) {
        shoppingRepository.searchShoppingList(query: .init(query: searchKeyword, page: page, sort: sort)) { result in
            var productList: [Product] = []
            switch result {
            case .success(let page):
                page.productList.forEach { product in
                    let isContainBookmakr = self.bookmarkRepository.checkContainInBookmark(product: product)
                    productList.append(Product(id: product.id, title: product.title, imagePath: product.imagePath, price: product.price, detailLink: product.detailLink, mall: product.mall, like: isContainBookmakr))
                }
                completion(.success(ProductPage(totalPage: page.totalPage, currentPage: page.currentPage, productList: productList)))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
}
