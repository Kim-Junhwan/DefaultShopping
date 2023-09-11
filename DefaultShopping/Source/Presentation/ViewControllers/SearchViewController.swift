//
//  SearchViewController.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/10.
//

import UIKit

class SearchViewController: BaseViewController {
    
    let productListView = ProductSearchListView()
    lazy var productListDelegateDatasource = ProductCollectionViewDelegateDatasource(viewController: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        productListView.productListCollectionView.reloadData()
    }
    
    override func loadView() {
        view = productListView
    }
    
    override func configureView() {
        super.configureView()
        productListView.productListCollectionView.delegate = productListDelegateDatasource
        productListView.productListCollectionView.dataSource = productListDelegateDatasource
    }
    
    override func setConstraints() {
        super.setConstraints()
        title = "쇼핑검색"
    }

}
