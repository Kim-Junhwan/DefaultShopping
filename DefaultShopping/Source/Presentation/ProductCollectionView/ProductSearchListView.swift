//
//  ProductSearchListView.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/10.
//

import UIKit
import SnapKit

protocol ProductSearchListViewDelegate: AnyObject {
    func fetchNextProductList(keyword: String)
    func tapProductCollectionView(product: Product)
    func productCollectionViewItemCount() -> Int
    func productCollectionViewCellForRowAt(at indexPath: IndexPath) -> Product?
    func tapLikeButton(index: Int) -> Bool?
    func search(keyword: String, selectedSort: Sort)
    func realTimeSearch(keyword: String)
    func reloadData(keyword: String, selectedSort: Sort, endRefresh: @escaping () -> Void)
}

extension ProductSearchListViewDelegate {
    func search(keyword: String, selectedSort: Sort) {}
    func realTimeSearch(keyword: String) {}
}

final class ProductSearchListView: UIView {
    
    let stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    lazy var searchBar: UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.barTintColor = .black
        searchBar.searchTextField.textColor = .white
        searchBar.tintColor = .white
        searchBar.delegate = self
        return searchBar
    }()

    lazy var productListCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.keyboardDismissMode = .onDrag
        collectionView.delegate = productCollectionViewDeleData
        collectionView.dataSource = productCollectionViewDeleData
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.tintColor = .white
        collectionView.refreshControl?.addTarget(self, action: #selector(productCollectionViewRefresh), for: .valueChanged)
        return collectionView
    }()
    
    lazy var sortButtonCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.backgroundColor = .clear
        collectionView.register(SortCollectionViewCell.self, forCellWithReuseIdentifier: SortCollectionViewCell.identifier)
        collectionView.delegate = sortCollectionViewDeleData
        collectionView.dataSource = sortCollectionViewDeleData
         return collectionView
     }()
    
    lazy var productCollectionViewDeleData: ProductListDelegateDatasource = {
        let deledelta = ProductListDelegateDatasource()
        deledelta.delegate = self
        return deledelta
    }()
    lazy var sortCollectionViewDeleData: SortCollectionViewDeleDatasource = {
        let deledelta = SortCollectionViewDeleDatasource()
        deledelta.delegate = self
        return deledelta
    }()
    
    weak var delegate: ProductSearchListViewDelegate?
    
    private var selectSort: Sort {
        get {
            return Sort.allCases[sortButtonCollectionView.indexPathsForSelectedItems?.first?.row ?? 0]
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setConstraints()
        setSortCollectionViewFlowlayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setProductCollectionViewFlowlayout()
    }
    
    private func configureView() {
        addSubview(stackView)
        stackView.addArrangedSubview(searchBar)
        stackView.addArrangedSubview(sortButtonCollectionView)
        stackView.addArrangedSubview(productListCollectionView)
        sortButtonCollectionView.selectItem(at: [0,0], animated: false, scrollPosition: .init())
    }
    
    private func setConstraints() {
        backgroundColor = .black
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        searchBar.setContentHuggingPriority(.init(150), for: .vertical)
        searchBar.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        sortButtonCollectionView.setContentHuggingPriority(.init(250), for: .vertical)
        sortButtonCollectionView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        productListCollectionView.setContentHuggingPriority(.init(249), for: .vertical)
        productListCollectionView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
    
    func setProductCollectionViewFlowlayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: .zero, left: 10, bottom: .zero, right: 10)
        let itemSize = (productListCollectionView.frame.width - Double(40)) / Double(2)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 15
        flowLayout.itemSize = CGSize(width: itemSize, height: itemSize * 1.7 )
        productListCollectionView.collectionViewLayout = flowLayout
    }
    
    private func setSortCollectionViewFlowlayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: .zero, left: 10, bottom: .zero, right: 10)
        flowLayout.minimumLineSpacing = 10
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.scrollDirection = .horizontal
        sortButtonCollectionView.collectionViewLayout = flowLayout
    }
    
    @objc private func productCollectionViewRefresh() {
        guard let searchKeyword = searchBar.text else { return }
        if searchKeyword.isEmpty {
            self.productListCollectionView.refreshControl?.endRefreshing()
            return
        }
        delegate?.reloadData(keyword: searchKeyword, selectedSort: selectSort, endRefresh: {
            self.productListCollectionView.refreshControl?.endRefreshing()
        })
    }
}

extension ProductSearchListView: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchKeyword = searchBar.text else { return }
        delegate?.search(keyword: searchKeyword, selectedSort: selectSort)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchKeyword = searchBar.text else { return }
        delegate?.realTimeSearch(keyword: searchKeyword)
    }
}

extension ProductSearchListView: ProductListDeleDataObjectDelegate {
    
    func productCount() -> Int {
        return delegate?.productCollectionViewItemCount() ?? 0
    }
    
    func cellForRowAt(at indexPath: IndexPath) -> Product? {
        return delegate?.productCollectionViewCellForRowAt(at: indexPath)
    }
    
    func fetchNextPage() {
        guard let searchKeyword = searchBar.text else { return }
        delegate?.fetchNextProductList(keyword: searchKeyword)
    }
    
    func tapProductCell(product: Product) {
        delegate?.tapProductCollectionView(product: product)
    }
    
    func tapLikeButton(index: Int) -> Bool? {
        return delegate?.tapLikeButton(index: index)
    }
}

extension ProductSearchListView: SortCollectiontDeleDataObjectDelegate {
    func tapSortCell(selectedSort: Sort) {
        guard let searchKeyword = searchBar.text else { return }
        delegate?.search(keyword: searchKeyword, selectedSort: selectedSort)
    }
    
}
