//
//  SearchViewController.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/10.
//

import UIKit

class SearchViewController: BaseViewController {
    
    let productListView = ProductSearchListView()
    let realmRepository: BookmarkRepository
    var searchUseCase: SearchProductUseCase
    var bookmarkUseCase: SetBookmarkUseCase
    
    var currentPage: Int = 0
    var totalPage: Int = 1
    var hasMorePage: Bool {
        get {
            currentPage < totalPage
        }
    }
    var nextPage: Int {
        get {
            hasMorePage ? currentPage + 1 : currentPage
        }
    }
    var isFetching: Bool = false
    var productList: [Product] = []
    
    init(realmRepository: BookmarkRepository, searchUseCase: SearchProductUseCase, bookmarkUseCase: SetBookmarkUseCase) {
        self.realmRepository = realmRepository
        self.searchUseCase = searchUseCase
        self.bookmarkUseCase = bookmarkUseCase
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productListView.productListCollectionView.delegate = self
        productListView.productListCollectionView.dataSource = self
        productListView.sortButtonCollectionView.delegate = self
        productListView.sortButtonCollectionView.dataSource = self
        productListView.sortButtonCollectionView.selectItem(at: [0,0], animated: false, scrollPosition: .init())
        
    }
    
    override func loadView() {
        view = productListView
    }
    
    override func configureView() {
        super.configureView()
        productListView.delegate = self
    }
    
    override func setConstraints() {
        super.setConstraints()
        title = "쇼핑검색"
    }
    
    @objc func tapLikeButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        var selectProduct = productList[sender.tag]
        selectProduct.like = true
        do {
            try bookmarkUseCase.setBookmark(product: selectProduct)
        } catch {
            self.showErrorAlert(error: error)
        }
    }

}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productListView.sortButtonCollectionView {
            return Sort.allCases.count
        } else {
            return productList.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == productListView.sortButtonCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SortCollectionViewCell.identifier, for: indexPath) as? SortCollectionViewCell else { return .init() }
            cell.sortTitleLabel.text = Sort.allCases[indexPath.row].title
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else { return .init() }
            cell.likeButton.tag = indexPath.row
            cell.likeButton.addTarget(self, action: #selector(tapLikeButton), for: .touchUpInside)
            cell.configureCell(product: productList[indexPath.row])
            return cell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == productListView.productListCollectionView {
            let detailVC = DetailViewController(product: productList[indexPath.row], bookmarkRepository: realmRepository)
            navigationController?.pushViewController(detailVC, animated: true)
        } else {
            if !productListView.searchBar.text!.isEmpty {
                search(keyword: productListView.searchBar.text!)
            }
        }
    }
    
    func fetchProductList(keyword: String, sort: Sort = .sim) {
        isFetching = true
        if keyword.isEmpty {
            productList.removeAll()
            productListView.productListCollectionView.reloadData()
            return
        }
        searchUseCase.search(searchKeyword: keyword, page: nextPage, sort: sort) { result in
            switch result {
            case .success(let success):
                self.currentPage = success.currentPage
                self.totalPage = success.totalPage
                self.productList.append(contentsOf: success.productList)
                self.productListView.productListCollectionView.reloadData()
            case .failure(let failure):
                self.showErrorAlert(error: failure)
            }
            self.isFetching = false
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y >=  (scrollView.contentSize.height-(scrollView.frame.height-tabBarController!.tabBar.frame.height)) && !isFetching && hasMorePage {
            isFetching = true
            let selectedSorted = Sort.allCases[productListView.sortButtonCollectionView.indexPathsForSelectedItems?.first?.row ?? 0]
            fetchProductList(keyword: self.productListView.searchBar.text!, sort: selectedSorted)
        }
        isFetching = false
    }
}

extension SearchViewController: ProductSearchListViewDelegate {
    
    func search(keyword: String) {
        self.currentPage = 0
        self.totalPage = 1
        productList.removeAll()
        productListView.productListCollectionView.reloadData()
        let selectedSorted = Sort.allCases[productListView.sortButtonCollectionView.indexPathsForSelectedItems?.first?.row ?? 0]
        fetchProductList(keyword: keyword, sort: selectedSorted)
    }
    
}
