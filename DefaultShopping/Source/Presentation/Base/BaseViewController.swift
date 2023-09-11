//
//  BaseViewController.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/10.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setConstraints()
        setNavigationController()
    }
    
    private func setNavigationController() {
        let appearence = UINavigationBarAppearance()
        appearence.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearence
    }
    
    func configureView() {
        
    }
    
    func setConstraints() {
    }

}
