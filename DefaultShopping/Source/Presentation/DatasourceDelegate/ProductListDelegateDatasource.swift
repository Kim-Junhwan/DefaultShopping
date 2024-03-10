//
//  ProductListDelegateDatasource.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/12.
//

import Foundation
import UIKit

protocol ProductListDeleDataObjectDelegate: AnyObject {
    func fetchNextPage()
    func tapProductCell(product: Product)
    func productCount()-> Int
    func cellForRowAt(at indexPath: IndexPath) -> Product?
    func tapLikeButton(index: Int) -> Bool?
    func getListType() -> ListType
}

final class ProductListDelegateDatasource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    weak var delegate: ProductListDeleDataObjectDelegate?
    
    @objc private func tapLikeButton(_ sender: UIButton) {
        guard let delegate else { return }
        guard let result = delegate.tapLikeButton(index: sender.tag) else { return }
        sender.isSelected = result
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.productCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if delegate?.getListType() == .collectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else { return .init() }
            guard let product = delegate?.cellForRowAt(at: indexPath) else { return .init() }
            cell.configureCell(product: product)
            cell.likeButton.tag = indexPath.row
            cell.likeButton.addTarget(self, action: #selector(tapLikeButton), for: .touchUpInside)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TableProductCollectionViewCell.identifier, for: indexPath) as? TableProductCollectionViewCell else { return .init() }
            guard let product = delegate?.cellForRowAt(at: indexPath) else { return .init() }
            cell.configureCell(product: product)
            cell.likeButton.tag = indexPath.row
            cell.likeButton.addTarget(self, action: #selector(tapLikeButton), for: .touchUpInside)
            return cell
        }
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y >= (scrollView.contentSize.height-scrollView.frame.height) {
            delegate?.fetchNextPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let product = delegate?.cellForRowAt(at: indexPath) else { return }
        delegate?.tapProductCell(product: product)
    }
    
}
