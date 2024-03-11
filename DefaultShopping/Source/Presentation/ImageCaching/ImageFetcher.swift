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
    private let fetchQueue = OperationQueue()
    private var completionHandlers = [Int: [(ImageStatus)-> Void]]()
    
    init() {
        imageFetchingQueue.maxConcurrentOperationCount = 2
    }
    
    func fetchAsync(product: Product, completion: @escaping (ImageStatus)-> Void) {
        imageFetchingQueue.addOperation {
            let handlers = self.completionHandlers[product.id, default: []]
            self.completionHandlers[product.id] = handlers + [completion]
        }
        self.fetchImage(product: product)
    }
    
    func fetchedImage(product: Product) -> ImageStatus {
        guard let url = URL(string: product.imagePath) else { return .fail }
        guard let data = ImageCacheManager.shared.cache.cachedResponse(for: .init(url: url))?.data else { return .fail }
        if let safeImage = UIImage(data: data) {
            return .success(safeImage)
        }
        return .fail
    }
    
    func fetchImage(product: Product) {
        if let image = ImageCacheManager.shared.checkProfileImageInCache(imageURL: product.imagePath) {
            invokeCompletionHandlers(product: product, status: .success(image))
            return
        } else {
            let operation = ImageFetcherOperation(product: product)
            operation.completionBlock = { [weak operation] in
                guard let fetchStatus = operation?.status else { return }
                self.imageFetchingQueue.addOperation {
                    self.invokeCompletionHandlers(product: product, status: fetchStatus)
                }
            }
            fetchQueue.addOperation(operation)
        }
    }
    
    func cancelFetch(_ product: Product) {
        imageFetchingQueue.addOperation {
            self.fetchQueue.isSuspended = true
            defer {
                self.fetchQueue.isSuspended = false
            }
            self.operation(product: product)?.cancel()
            self.completionHandlers[product.id] = nil
        }
    }
    
    
    func operation(product: Product) -> ImageFetcherOperation? {
        for case let fetchOperation as ImageFetcherOperation in fetchQueue.operations
        where !fetchOperation.isCancelled && fetchOperation.product == product {
            return fetchOperation
        }
        return nil
    }
    
    private func invokeCompletionHandlers(product: Product, status: ImageStatus) {
        let completionHandlers = self.completionHandlers[product.id, default: []]
        self.completionHandlers[product.id] = nil
        
        for handler in completionHandlers {
            handler(status)
        }
    }
}

class ImageFetcherOperation: Operation {
    let product: Product
    private(set) var status: ImageStatus

    init(product: Product) {
        self.product = product
        status = .empty
    }

    override func main() {
        guard !isCancelled else { return }
        guard let url = URL(string: product.imagePath) else { return }
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 10.0
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url: url)
        status = .loading
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                self.status = .fail
            } else {
                guard let data, let response, let safeImage = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    ImageCacheManager.shared.cache.storeCachedResponse(.init(response: response, data: data), for: request)
                    self.status = .success(safeImage)
                }
            }
        }.resume()
    }
}
