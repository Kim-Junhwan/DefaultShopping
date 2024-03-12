//
//  ImageFetcher.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/13.
//

import Foundation
import UIKit

class ImageFetcher {
    private let imageFetchingQueue = OperationQueue()
    var loadingOperations: [Int: ImageFetcherOperation] = [:]
    
    init() {
        imageFetchingQueue.maxConcurrentOperationCount = 1
    }
    
    func fetchAsync(product: Product, completion: ((UIImage?)-> Void)? = nil) {
        if let fetchedImage = ImageCacheManager.shared.checkProfileImageInCache(imageURL: product.imagePath) {
            completion?(fetchedImage)
        }
        if let dataLoader = loadingOperations[product.id] {
            if let fetchImage = dataLoader.fetchedImage {
                loadingOperations.removeValue(forKey: product.id)
                completion?(fetchImage)
            } else {
                dataLoader.loadingCompletionHandler = completion
            }
        } else {
            fetchImage(product: product, completion: completion)
        }
    }
    
    func fetchImage(product: Product, completion: ((UIImage?)-> Void)? = nil) {
        let operation = ImageFetcherOperation(product: product)
        operation.loadingCompletionHandler = completion
        imageFetchingQueue.addOperation(operation)
        loadingOperations[product.id] = operation
    }
    
    func cancelFetch(_ product: Product) {
        if let productImageLoader = loadingOperations[product.id] {
            productImageLoader.cancel()
            loadingOperations.removeValue(forKey: product.id)
        }
    }
}

class ImageFetcherOperation: Operation {
    let product: Product
    private(set) var fetchedImage: UIImage?
    var loadingCompletionHandler: ((UIImage)-> Void)?

    init(product: Product) {
        self.product = product
    }

    override func main() {
        guard !isCancelled else { return }
        guard let url = URL(string: product.imagePath) else { return }
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 10.0
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url: url)
        session.dataTask(with: request) { data, response, error in
            if error == nil {
                guard !self.isCancelled else { return }
                guard let data, let response, let safeImage = UIImage(data: data) else { return }
                if let loadingCompletionHandler = self.loadingCompletionHandler {
                    DispatchQueue.main.async {
                        ImageCacheManager.shared.cache.setObject(safeImage, forKey: .init(string: self.product.imagePath))
                        loadingCompletionHandler(safeImage)
                    }
                }
            }
        }.resume()
    }
}
