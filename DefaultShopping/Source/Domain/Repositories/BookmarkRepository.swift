//
//  BookmarkRepository.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/08.
//

protocol BookmarkRepository {
    func saveProduct(product: Product) throws
    func checkContainInBookmark(product: Product) -> Bool
    func fetchSavedProcutPage(query: BookmarkSearchQuery) -> ProductPage
    func deleteProduct(product: Product) throws
}
