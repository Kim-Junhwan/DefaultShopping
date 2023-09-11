//
//  ProductListDelegateDatasource.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/10.
//

import Foundation
import UIKit

class ProductCollectionViewDelegateDatasource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    unowned private let viewController: UIViewController
    private var productList: [Product] = []
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func setProductList(productList: [Product]) {
        self.productList = productList
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else { return .init() }
        cell.configureCell(product: productList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
