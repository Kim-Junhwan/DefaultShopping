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
    
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func checkProfileImageInCache(imageURL: String) -> UIImage? {
        if let profileImage = cache.object(forKey: NSString(string: imageURL)) {
            return profileImage
        }
        return nil
    }
}
