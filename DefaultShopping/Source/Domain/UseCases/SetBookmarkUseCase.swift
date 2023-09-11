//
//  SetBookmarkUseCase.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/11.
//

import Foundation

protocol SetBookmarkUseCase {
    func setBookmark(product: Product) throws
}

final class RealmSetBookmarkUseCase {
    let bookmark: BookmarkRepository
    
    init(bookmark: BookmarkRepository) {
        self.bookmark = bookmark
    }
}

extension RealmSetBookmarkUseCase: SetBookmarkUseCase {
    
    func setBookmark(product: Product) throws {
        if bookmark.checkContainInBookmark(product: product) {
            try bookmark.deleteProduct(product: product)
        } else {
            try bookmark.saveProduct(product: product)
        }
    }
}
