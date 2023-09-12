//
//  SetBookmarkUseCase.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/11.
//

import Foundation

protocol SetBookmarkUseCase {
    func setBookmark(product: Product) throws -> Bool
}

final class RealmSetBookmarkUseCase {
    let bookmark: BookmarkRepository
    
    init(bookmark: BookmarkRepository) {
        self.bookmark = bookmark
    }
}

extension RealmSetBookmarkUseCase: SetBookmarkUseCase {
    func setBookmark(product: Product) throws -> Bool {
        if bookmark.checkContainInBookmark(product: product) {
            try bookmark.deleteProduct(product: product)
            return false
        } else {
            try bookmark.saveProduct(product: product)
            return true
        }
    }
}
