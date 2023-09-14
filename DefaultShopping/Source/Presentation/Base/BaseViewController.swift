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
        navigationController?.navigationBar.tintColor = .white
    }
    
    func configureView() {
    }
    
    func setConstraints() {
    }
    
    func showErrorAlert(error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default)
            alert.addAction(ok)
            self.present(alert, animated: true)
        }
    }

}
