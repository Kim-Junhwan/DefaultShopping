//
//  ShoppingSceneDIContainer.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/10.
//

import Foundation
import UIKit

class ShoppingDIContainer {
    
    lazy var naverapiconfig: NetworkConfiguration = {
       let apiconfig = NetworkConfiguration(baseURL: URL(string: "https://openapi.naver.com/")!, header: ["X-Naver-Client-Id":APIKey.clientID,"X-Naver-Client-Secret":APIKey.clientSecret], queryParameter: ["display":30])
        return apiconfig
    }()
    
    lazy var realmRepository: BookmarkRepository = {
        let realmBookmarkRepository = RealmBookmarkRepository()
        return realmBookmarkRepository
    }()
    
    lazy var naverNetworkService: NetworkService = {
        let networkService = DefaultNetworkService(config: naverapiconfig)
        
        return networkService
    }()
    
    lazy var dataTransferService: DataTransferService = {
        let dataTransferService = DataTransferService(networkService: naverNetworkService)
        
        return dataTransferService
    }()
    
    lazy var shoppingRepository: ShoppingRepository = {
       let repository = DefaultShoppingRepository(dataTransferService: dataTransferService)
        return repository
    }()
    
    lazy var bookmarkRepository: BookmarkRepository = {
        let repository = RealmBookmarkRepository()
        return repository
    }()
    
    lazy var searchProductUseCase: SearchProductUseCase = {
        let usecase = DefaultSearchProductUseCase(shoppingRepository: shoppingRepository, bookmarkRepository: bookmarkRepository)
        
        return usecase
    }()
    
    lazy var bookmarkUseCase: SetBookmarkUseCase = {
        let usecase = RealmSetBookmarkUseCase(bookmark: bookmarkRepository)
        return usecase
    }()
    
    func makeTabBarController(viewControllers: [UIViewController]) -> CustomTabBarViewController {
        let tabBarVC = CustomTabBarViewController()
        tabBarVC.setViewControllers(viewControllers, animated: false)
        return tabBarVC
    }
    
    func makeSearchViewController() -> SearchViewController {
        let searchVC = SearchViewController(realmRepository: realmRepository, searchUseCase: searchProductUseCase, bookmarkUseCase: bookmarkUseCase)
        searchVC.tabBarItem = .init(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        return searchVC
    }
    
    func makeBookmarkViewController() -> BookmarkViewController {
        let bookmarkVC = BookmarkViewController(realmReposity: realmRepository)
        bookmarkVC.tabBarItem = .init(title: "좋아요", image: UIImage(systemName: "heart"), tag: 1)
        return bookmarkVC
    }
}
