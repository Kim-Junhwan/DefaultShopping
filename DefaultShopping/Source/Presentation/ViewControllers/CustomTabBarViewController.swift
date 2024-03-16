//
//  CustomTabBarViewController.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/10.
//

import UIKit

class CustomTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .black
        tabBar.standardAppearance = appearance
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .gray
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
        guard let viewControllers else { return }
        let navVCList = viewControllers.map { UINavigationController(rootViewController: $0) }
        super.setViewControllers(navVCList, animated: animated)
    }
    
}
