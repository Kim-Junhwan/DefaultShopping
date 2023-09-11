//
//  DetailViewController.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/11.
//

import UIKit
import WebKit

final class DetailViewController: BaseViewController {
    
    lazy var isLikeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(tapLikeButton))
        return button
    }()
    
    let webView: WKWebView = {
        let webView = WKWebView()
        
        return webView
    }()
    
    let product: Product
    let bookmarkRepository: BookmarkRepository
    
    init(product: Product, bookmarkRepository: BookmarkRepository) {
        self.product = product
        self.bookmarkRepository = bookmarkRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = product.title
        guard let url = URL(string: "https://msearch.shopping.naver.com/product/\(product.id)") else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setLikeButtonImage(isLike: bookmarkRepository.checkContainInBookmark(product: product))
    }
    
    override func configureView() {
        view.addSubview(webView)
        navigationItem.setRightBarButton(isLikeButton, animated: false)
    }
    
    override func setConstraints() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc private func tapLikeButton() throws {
        let isLike = bookmarkRepository.checkContainInBookmark(product: product)
        if isLike {
            try bookmarkRepository.deleteProduct(product: product)
        } else {
            try bookmarkRepository.saveProduct(product: product)
        }
        setLikeButtonImage(isLike: !isLike)
    }
    
    func setLikeButtonImage(isLike: Bool) {
        if isLike {
            isLikeButton.image = UIImage(systemName: "heart.fill")
        } else {
            isLikeButton.image = UIImage(systemName: "heart")
        }
    }
}
