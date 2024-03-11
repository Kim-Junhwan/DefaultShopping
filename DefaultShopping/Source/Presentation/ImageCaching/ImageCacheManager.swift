//
//  ImageCacheManager.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2024/03/11.
//

import Foundation
import UIKit

final class ImageCacheManager {
    
    static let shared = ImageCacheManager()
    
    let cache = URLCache.shared
    
    private init() {}
    
    func checkProfileImageInCache(imageURL: String) -> UIImage? {
        guard let url = URL(string: imageURL) else { return nil }
        if let chachedResponse = cache.cachedResponse(for: .init(url: url)) {
            return .init(data: chachedResponse.data)
        }
        return nil
    }
}
