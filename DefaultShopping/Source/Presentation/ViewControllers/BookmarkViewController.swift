//
//  BookmarkViewController.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/10.
//

import UIKit

class BookmarkViewController: BaseViewController {
    
    let productListView = ProductSearchListView()
    
    let realmReposity: BookmarkRepository
    
    var productList: [Product] = []
    
    init(realmReposity: BookmarkRepository) {
        self.realmReposity = realmReposity
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "좋아요 목록"
        productListView.delegate = self
        productListView.sortButtonCollectionView.isHidden = true
        productListView.productListCollectionView.delegate = self
        productListView.productListCollectionView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        productList = realmReposity.fetchSavedProductList(displayCount: 30)
        productListView.productListCollectionView.reloadData()
    }
    
    override func loadView() {
        view = productListView
    }
    
    @objc func tapLikeButton(_ sender: UIButton) {
        try! self.realmReposity.deleteProduct(product: self.productList[sender.tag])
        productList = realmReposity.fetchSavedProductList(displayCount: 30)
        productListView.productListCollectionView.reloadData()
    }

}

extension BookmarkViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else { return .init() }
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(tapLikeButton), for: .touchUpInside)
        cell.configureCell(product: productList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailViewController(product: productList[indexPath.row], bookmarkRepository: realmReposity)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension BookmarkViewController: ProductSearchListViewDelegate {
    
    func search(keyword: String) {
        if keyword.isEmpty {
            productList = realmReposity.fetchSavedProductList(displayCount: 30)
        } else {
            productList = realmReposity.searchProducts(title: keyword)
        }
        productListView.productListCollectionView.reloadData()
    }
    
}
