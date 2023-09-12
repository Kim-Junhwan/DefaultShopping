//
//  SortCollectionViewDeleData.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/13.
//

import Foundation
import UIKit

protocol SortCollectiontDeleDataObjectDelegate: AnyObject {
    func tapSortCell(selectedSort: Sort)
}

final class SortCollectionViewDeleDatasource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    weak var delegate: SortCollectiontDeleDataObjectDelegate?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Sort.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SortCollectionViewCell.identifier, for: indexPath) as? SortCollectionViewCell else { return .init() }
        cell.sortTitleLabel.text = Sort.allCases[indexPath.row].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.tapSortCell(selectedSort: Sort.allCases[indexPath.row])
    }
    
}
