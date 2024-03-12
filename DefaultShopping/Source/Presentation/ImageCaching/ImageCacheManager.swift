//
//  ImageCacheManager.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/13.
//

import Foundation
import UIKit

final class ImageCacheManager {
    
    static let shared = ImageCacheManager()
    
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func checkProfileImageInCache(imageURL: String) -> UIImage? {
        if let image = cache.object(forKey: .init(string: imageURL)) {
            return image
        }
        return nil
    }
}
