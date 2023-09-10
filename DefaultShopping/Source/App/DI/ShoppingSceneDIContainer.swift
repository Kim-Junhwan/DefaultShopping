//
//  ShoppingSceneDIContainer.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/10.
//

import Foundation
import UIKit

class ShoppingDIContainer {
    func makeTabBarController(viewControllers: [UIViewController]) -> CustomTabBarViewController {
        let tabBarVC = CustomTabBarViewController()
        tabBarVC.setViewControllers(viewControllers, animated: false)
        return tabBarVC
    }
    
    func makeSearchViewController() -> SearchViewController {
        let searchVC = SearchViewController()
        searchVC.tabBarItem = .init(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        return searchVC
    }
    
    func makeBookmarkViewController() -> BookmarkViewController {
        let bookmarkVC = BookmarkViewController()
        bookmarkVC.tabBarItem = .init(title: "좋아요", image: UIImage(systemName: "heart"), tag: 1)
        return bookmarkVC
    }
}
