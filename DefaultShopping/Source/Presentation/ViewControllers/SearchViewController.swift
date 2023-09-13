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
        productListView.productListCollectionView.reloadData()
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
}

extension SearchViewController: ProductSearchListViewDelegate {
    func productCollectionViewItemCount() -> Int {
        return productList.count
    }
    
    func productCollectionViewCellForRowAt(at indexPath: IndexPath) -> Product? {
        return productList[indexPath.row]
    }
    
    func search(keyword: String, selectedSort: Sort) {
        self.currentPage = 0
        self.totalPage = 1
        productList.removeAll()
        productListView.productListCollectionView.reloadData()
        fetchProductList(keyword: keyword, sort: selectedSort)
    }
    
    func fetchNextProductList(keyword: String) {
        if hasMorePage {
            fetchProductList(keyword: keyword)
        }
    }
    
    func tapProductCollectionView(product: Product) {
        let vc = DetailViewController(product: product, bookmarkRepository: realmRepository)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tapLikeButton(index: Int) -> Bool? {
        let selectedProduct = productList[index]
        do {
            let result = try bookmarkUseCase.setBookmark(product: selectedProduct)
            return result
        } catch {
            showErrorAlert(error: error)
            return nil
        }
    }
    
}
