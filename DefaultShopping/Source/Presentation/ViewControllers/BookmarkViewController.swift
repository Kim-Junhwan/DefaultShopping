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
    
    init(realmReposity: BookmarkRepository) {
        self.realmReposity = realmReposity
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setLeftBarButton(productListView.listTypeButton, animated: false)
        fetchProductList()
    }
    
    override func configureView() {
        title = "좋아요 목록"
        productListView.sortButtonCollectionView.isHidden = true
        productListView.delegate = self
    }
    
    override func loadView() {
        view = productListView
    }
    
    private func fetchProductList(title: String = "") {
        let fetchProductList = realmReposity.fetchSavedProcutPage(query: .init(title: title, page: nextPage))
        currentPage = fetchProductList.currentPage
        totalPage = fetchProductList.totalPage
        productList.append(contentsOf: fetchProductList.productList)
        
    }

    private func set(product: Product) throws -> Bool {
        if realmReposity.checkContainInBookmark(product: product) {
            try realmReposity.deleteProduct(product: product)
            return false
        } else {
            try realmReposity.saveProduct(product: product)
            return true
        }
    }
    
    private func resetPage() {
        productList.removeAll()
        currentPage = 0
        totalPage = 1
    }
    
}

extension BookmarkViewController: ProductSearchListViewDelegate {
    
    func productCollectionViewCellForRowAt(at indexPath: IndexPath) -> Product? {
        return productList[indexPath.row]
    }
    
    func productCollectionViewItemCount() -> Int {
        return productList.count
    }
    
    func realTimeSearch(keyword: String) {
        resetPage()
        if keyword.isEmpty {
            fetchProductList()
        } else {
            fetchProductList(title: keyword)
        }
        productListView.productListCollectionView.reloadData()
    }
    
    func fetchNextProductList(keyword: String) {
        if hasMorePage {
            fetchProductList(title: keyword)
            productListView.productListCollectionView.reloadData()
        }
    }
    
    func tapProductCollectionView(product: Product) {
        let vc = DetailViewController(product: product, bookmarkRepository: realmReposity)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tapLikeButton(index: Int) -> Bool? {
        let product = productList[index]
        let repeatNum = currentPage
        do {
            let result = try set(product: product)
            resetPage()
            for _ in 0..<repeatNum {
                fetchProductList()
            }
            productListView.productListCollectionView.reloadData()
            return result
        } catch {
            showErrorAlert(error: error)
            return nil
        }
    }
    
    func reloadData(keyword: String, selectedSort: Sort, endRefresh: @escaping () -> Void) {
        resetPage()
        fetchProductList(title: keyword)
        endRefresh()
        productListView.productListCollectionView.reloadData()
    }
    
}
