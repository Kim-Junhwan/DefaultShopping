//
//  UIImageView+.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/10.
//

import Foundation
import UIKit

extension UIImageView {
    func setImageFromImagePath(imagePath: String) {
        guard let url = URL(string: imagePath) else { return }
        URLSession.shared.dataTask(with: .init(url: url)) { data, response, error in
            let fetchImage: UIImage?
            if let error {
                guard let httpResponse = response as? HTTPURLResponse else { return }
                if (200...500)~=httpResponse.statusCode {
                    print(NetworkError.responseError(statusCode: httpResponse.statusCode, data: data))
                } else {
                    print(NetworkError.networkError(error: error))
                }
                fetchImage = UIImage(named: "ready")
            } else {
                guard let data else { return }
                fetchImage = UIImage(data: data)
            }
            DispatchQueue.main.async {
                self.image = fetchImage
            }
        }.resume()
    }
}
