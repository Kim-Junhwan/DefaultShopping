//
//  DefaultBookmarkRepository.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/09.
//

import Foundation
import RealmSwift

class BookmarkedProduct: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String
    @Persisted var imagePath: String
    @Persisted var price: Int
    @Persisted var detailLink: String
    @Persisted var mall: String
    
    convenience init(id: Int, title: String, imagePath: String, price: Int, detailLink: String, mall: String) {
        self.init()
        self.id = id
        self.title = title
        self.imagePath = imagePath
        self.price = price
        self.detailLink = detailLink
        self.mall = mall
    }
    
    func toDomain() -> Product {
        return .init(id: id, title: title, imagePath: imagePath, price: price, detailLink: detailLink, mall: mall, like: true)
    }
}

final class RealmBookmarkRepository {
    let realm = try? Realm()
}

extension RealmBookmarkRepository: BookmarkRepository {
    func saveProduct(product: Product) throws {
        guard let realm else { return }
        try realm.write {
            realm.add(BookmarkedProduct(id: product.id, title: product.title, imagePath: product.imagePath, price: product.price, detailLink: product.detailLink, mall: product.mall))
        }
    }
    
    func checkContainInBookmark(product: Product) -> Bool {
        guard let realm else { return false }
        if realm.object(ofType: BookmarkedProduct.self, forPrimaryKey: product.id) == nil {
            return false
        }
        return true
    }
    
    func fetchSavedProductList(displayCount: Int) -> [Product] {
        guard let realm else { return [] }
        let fetchObject = realm.objects(BookmarkedProduct.self)
        return fetchObject.map { $0.toDomain() }
    }
    
    func deleteProduct(product: Product) throws {
        guard let realm else { return }
        try realm.write {
            realm.delete(BookmarkedProduct(id: product.id, title: product.title, imagePath: product.imagePath, price: product.price, detailLink: product.detailLink, mall: product.mall))
        }
    }
}
