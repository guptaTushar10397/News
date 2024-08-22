//
//  ImageCache.swift
//  News
//
//  Created by Tushar Gupta on 22/08/24.
//

import UIKit

final class ImageCache {
    static let shared = ImageCache()

    private init() {}
    private var cache = NSCache<NSString, UIImage>()

    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }

    func save(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
